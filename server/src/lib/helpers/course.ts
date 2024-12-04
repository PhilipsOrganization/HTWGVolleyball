import { accounts, courseSpots, courses, type Account, type Course, type DB } from '$lib/db/schema';
import { error } from '@sveltejs/kit';
import { sanitizeUser, type SanitizedAccount } from './account';
import { Role } from '$lib/db/role';
import { eq, getTableColumns, sql } from 'drizzle-orm';

export function serializeCourse(course: Course, accounts: Account[], user?: Account) {
	if (!course) {
		error(404, 'Course not found');
	}

	accounts = accounts.filter((a) => a !== null);
	const signupCount = accounts.filter((a) => a.canceledAt === null).length;

	if (course.id === 255) {
		console.log('accounts', accounts, signupCount, course);
	}

	const serialized = {
		...course,
		signupCount,
		participants: [] as SanitizedAccount[],
		isEnrolled: false,
		isOnWaitlist: false,
		spot: 0,
		isPast: isCourseInThePast(course)
	};

	if (!user) {
		return serialized;
	}

	// Only show participants if the user is an admin
	if (user.role !== Role.USER) {
		serialized.participants = accounts.map(sanitizeUser);
	}

	const enrollment = accounts.find((a) => a.id === user.id);
	const isEnrolled = !!enrollment && !enrollment.canceledAt;
	const spot = accounts.findIndex((a) => a.id === user.id);
	const isOnWaitlist = spot >= course.maxParticipants;

	return {
		...serialized,
		isEnrolled,
		spot,
		isOnWaitlist
	};
}

export async function getCourseUsers(db: DB, id: number) {
	const res = await db
		.select({
			...getTableColumns(accounts),
			canceledAt: courseSpots.deletedAt
		})
		.from(courseSpots)
		.rightJoin(accounts, eq(courseSpots.userId, accounts.id))
		.orderBy(courseSpots.createdAt)
		.where(eq(courseSpots.courseId, id));

	return res;
}

export async function getCourse(db: DB, id: number) {
	const [course] = await db
		.select({
			...getTableColumns(courses),
			shouldPublish: sql<boolean>`(${courses.publishOn} <= NOW() AND ${courses.date} >= (NOW() - INTERVAL '1 day'))`.as('shouldPublish')
		})
		.from(courses)
		.where(eq(courses.id, id))
		.limit(1);

	return course;
}

export function isCourseInThePast(course: Course) {
	const clone = new Date(course.date);
	const [hours, minutes] = course.time.split(':').map((n) => parseInt(n));
	clone.setHours(hours, minutes, 0, 0);

	return clone < new Date();
}
