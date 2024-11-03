import { Role } from '$lib/db/role';
import { accounts, courseSpots, courses, type Course, type DB } from '$lib/db/schema.js';
import { sendEmail } from '$lib/email';
import OpenSpot from '$lib/email/templates/open-spot.svelte';
import RecievedStrike from '$lib/email/templates/recieved-strike.svelte';
import { serializeUser } from '$lib/helpers/account.js';
import { getCourseWithUsers, isCourseInThePast, serializeCourse } from '$lib/helpers/course.js';
import { DropCourseAction, OpenCourseAction, OpenProfileAction, sendNotification } from '$lib/helpers/notification';
import { error, redirect } from '@sveltejs/kit';
import { and, eq, gte, lte, not, sql } from 'drizzle-orm';
import type { PageServerLoad } from './$types.js';

export const load: PageServerLoad = async ({ locals, params }) => {
	if (!locals.user) {
		redirect(303, '/login');
	}

	const id = parseInt(params.id);
	const course = await getCourseWithUsers(locals.db, id);

	if (!course || !course.courses) {
		error(400, 'Course not found');
	}

	if (!course.shouldPublish && locals.user.role === Role.USER) {
		error(400, 'Course not jet published');
	}

	return {
		course: serializeCourse(course, locals.user),
		user: serializeUser(locals.user)
	};
};

async function notifyNextUser(course: Course, db: DB) {
	const spots = course.maxParticipants;

	const users = await db
		.select()
		.from(courseSpots)
		.leftJoin(accounts, eq(courseSpots.userId, accounts.id))
		.where(eq(courseSpots.courseId, course.id))
		.orderBy(courseSpots.createdAt);

	// If there are no users on the waitlist, return
	if (users.length <= spots) {
		return;
	}

	// Get the user on the waitlist that is next in line
	const userOnWaitlist = users.at(spots - 1);
	if (!userOnWaitlist || !userOnWaitlist.accounts) {
		return;
	}

	// Notify the user that a spot has opened up
	if (userOnWaitlist.accounts.subscriptionAuth) {
		return sendNotification(userOnWaitlist.accounts, `A spot in ${course.name} Course has opened up for you!`, [
			new OpenCourseAction(course.id),
			new DropCourseAction(course.id)
		]);
	} else {
		return sendEmail(OpenSpot, {
			user: userOnWaitlist.accounts,
			subject: `A spot in ${course.name} Course has opened up for you!`,
			props: { course, user: userOnWaitlist }
		});
	}
}

export const actions = {
	enlist: async ({ locals, params }) => {
		if (!locals.user) {
			redirect(303, '/login');
		}

		if (!locals.user.emailVerified) {
			error(400, 'Your Email is not verified. Check your inbox for the verification email or request a new one in your profile.');
		}

		const courseIdString = params.id as string | undefined;
		if (!courseIdString) {
			error(400, 'No courseId provided');
		}

		const courseId = parseInt(courseIdString);

		const [course] = await locals.db
			.select({
				courses,
				shouldPublish: sql<boolean>`(${courses.publishOn} <= NOW() AND ${courses.date} >= (NOW() - INTERVAL '1 day'))`.as('shouldPublish')
			})
			.from(courses)
			.where(eq(courses.id, courseId))
			.limit(1);

		if (!course) {
			error(400, 'Course not found');
		}

		if (isCourseInThePast(course.courses)) {
			error(400, 'Course is in the past');
		}

		if (locals.user.role === Role.USER && !course.shouldPublish) {
			error(400, 'Course not jet published');
		}

		const [isEnrolled] = await locals.db
			.select()
			.from(courseSpots)
			.where(and(eq(courseSpots.userId, locals.user.id), eq(courseSpots.courseId, courseId)))
			.limit(1);

		if (isEnrolled) {
			error(400, 'Already enrolled');
		}

		if (!course.courses.allowDoubleBookings) {
			const date = new Date(course.courses.date);
			const dateWithoutTime = date.toISOString().split('T')[0];
			const nextDayWithoutTime = new Date(date.getTime() + 24 * 60 * 60 * 1000).toISOString().split('T')[0];

			const [isBooked] = await locals.db
				.select()
				.from(courseSpots)
				.leftJoin(courses, eq(courseSpots.courseId, courses.id))
				.where(
					and(
						// find all courses that are not the current course
						eq(courseSpots.userId, locals.user.id),
						// find all courses that are on the same day
						gte(courses.date, dateWithoutTime),
						lte(courses.date, nextDayWithoutTime)
					)
				)
				.limit(1);

			console.log('isBooked', isBooked);

			if (isBooked) {
				error(400, 'You have already booked a course on this day.');
			}
		}

		await locals.db.insert(courseSpots).values({
			userId: locals.user.id,
			courseId: courseId
		});

		const updated = await getCourseWithUsers(locals.db, courseId);

		return {
			course: serializeCourse(updated, locals.user)
		};
	},
	drop: async ({ locals, params }) => {
		if (!locals.user) {
			redirect(303, '/login');
		}

		const courseIdString = params.id as string | undefined;
		if (!courseIdString) {
			error(400, 'No courseId provided');
		}

		const courseId = parseInt(courseIdString);
		const [course] = await locals.db.select().from(courses).where(eq(courses.id, courseId)).limit(1);
		if (!course) {
			error(400, 'Course not found');
		}

		if (isCourseInThePast(course)) {
			error(400, 'Course is in the past');
		}

		const [isEnrolled] = await locals.db
			.select()
			.from(courseSpots)
			.where(and(eq(courseSpots.userId, locals.user.id), eq(courseSpots.courseId, courseId)))
			.limit(1);

		if (!isEnrolled) {
			error(400, 'Not enrolled');
		}

		await locals.db.delete(courseSpots).where(and(eq(courseSpots.userId, locals.user.id), eq(courseSpots.courseId, courseId)));

		const updated = await getCourseWithUsers(locals.db, courseId);

		if (updated.courses) {
			notifyNextUser(updated.courses, locals.db);
		}

		return {
			course: serializeCourse(updated, locals.user)
		};
	},
	'delete-course': async ({ locals, params }) => {
		if (!locals.user || locals.user.role === Role.USER) {
			redirect(303, '/login');
		}

		const courseIdString = params.id as string | undefined;
		if (!courseIdString) {
			error(400, 'No courseId provided');
		}

		const courseId = parseInt(courseIdString);
		const [course] = await locals.db.select().from(courses).where(eq(courses.id, courseId)).limit(1);

		if (!course) {
			error(400, 'Course not found');
		}

		await locals.db.transaction(async (db) => {
			await db.delete(courseSpots).where(eq(courseSpots.courseId, courseId));
			await db.delete(courses).where(eq(courses.id, courseId));
		});

		redirect(303, `/admin`);
	},
	cancel: async ({ locals, request, params }) => {
		if (!locals.user || locals.user.role === Role.USER) {
			redirect(303, '/login');
		}

		const form = await request.formData();
		const courseId = parseInt(params.id as string);
		const [course] = await locals.db.select().from(courses).where(eq(courses.id, courseId)).limit(1);

		const userIdString = form.get('userId') as string | undefined;
		if (!userIdString) {
			error(400, 'No userId provided');
		}

		const userId = parseInt(userIdString);
		await locals.db.delete(courseSpots).where(and(eq(courseSpots.userId, userId), eq(courseSpots.courseId, courseId)));

		notifyNextUser(course, locals.db);

		const updated = await getCourseWithUsers(locals.db, courseId);
		return {
			course: serializeCourse(updated, locals.user)
		};
	},
	strike: async ({ locals, request, params }) => {
		if (!locals.user || locals.user.role === Role.USER) {
			redirect(303, '/login');
		}

		const form = await request.formData();
		const courseId = parseInt(params.id as string);
		const [course] = await locals.db.select().from(courses).where(eq(courses.id, courseId)).limit(1);

		const userIdString = form.get('userId') as string | undefined;
		if (!userIdString) {
			error(400, 'No userId provided');
		}

		const userId = parseInt(userIdString);
		// const user = await locals.db.select().from(accounts).where(eq(accounts.id, userId)).limit(1);

		await locals.db
			.update(accounts)
			.set({ strikes: sql`${accounts.strikes} + 1` })
			.where(eq(accounts.id, userId));
		const [user] = await locals.db.select().from(accounts).where(eq(accounts.id, userId)).limit(1);

		if (user.subscriptionAuth) {
			sendNotification(user, `You have been striked for Course "${course.name}" by ${locals.user.username}`, [
				new OpenCourseAction(course.id),
				new OpenProfileAction()
			]);
		} else {
			sendEmail(RecievedStrike, {
				user: user,
				subject: `You have been striked for Course "${course.name}" by ${locals.user.username}`,
				props: { course, user: user, admin: locals.user }
			});
		}
	}
};
