import { dev } from '$app/environment';
import { accounts, courseSpots, courseTemplateTable, courses, type CourseTemplate, type DB } from '$lib/db/schema.js';
import { sendEmail } from '$lib/email/index.js';
import CourseNotification from '$lib/email/templates/course-notification.svelte';
import AutoCreatedNotification from '$lib/email/templates/auto-created.svelte';
import { hydrateCourseTemplate } from '$lib/helpers/courseTemplate';
import { OpenCourseAction, sendNotification } from '$lib/helpers/notification.js';
import * as Sentry from '@sentry/sveltekit';
import type { RequestHandler } from '@sveltejs/kit';
import { differenceInHours, endOfWeek, isToday, startOfWeek } from 'date-fns';
import { and, eq, gt, gte, isNull, lt, lte, sql } from 'drizzle-orm';

export const GET: RequestHandler = async ({ locals }) => {
	const checkInId = Sentry.captureCheckIn({
		monitorSlug: 'notification-cron',
		status: 'in_progress'
	});

	const db = locals.db;

	try {
		const result = await db
			.select()
			.from(courses)
			.where(
				and(
					eq(courses.notificationSent, false),
					lte(courses.publishOn, sql`NOW()`), // Only show courses that have been published
					gte(courses.date, sql`NOW() - INTERVAL '1 day'`) // Only show courses that are 24 hours in the future
				)
			);

		console.log(`Found ${result.length} courses to send notifications for`);

		for (const course of result) {
			const [hours, minutes] = course.time.split(':').map(Number);
			const date = new Date(course.date);
			date.setHours(hours, minutes, 0, 0);
			const hoursToCourse = differenceInHours(date, new Date());
			if (!isToday(date) || hoursToCourse > 6) {
				continue;
			}

			if (!dev && course.notificationSent) {
				continue;
			}

			await db.update(courses).set({ notificationSent: true }).where(eq(courses.id, course.id));

			console.log(`Sending notifications for course ${course.id}`);
			const usersInCourse = await db
				.select()
				.from(courseSpots)
				.leftJoin(accounts, eq(courseSpots.userId, accounts.id))
				.where(and(eq(courseSpots.courseId, course.id), isNull(courseSpots.deletedAt)));

			for (const user of usersInCourse) {
				if (user.accounts?.subscriptionAuth) {
					try {
						await sendNotification(user.accounts, `You have a course today: ${course.name}`, [new OpenCourseAction(course.id)]);
					} catch (e) {
						await db
							.update(accounts)
							.set({ subscriptionAuth: null, subscriptionEndpoint: null, subscriptionExpirationTime: null, subscriptionP256Dh: null })
							.where(eq(accounts.id, user.accounts.id));
					}
				}

				if (user.accounts && (!user.accounts.subscriptionAuth || dev)) {
					await sendEmail(CourseNotification, {
						user: user.accounts,
						subject: `You have a course today: ${course.name}`,
						props: { course, user }
					});
				}
			}
		}

		Sentry.captureCheckIn({
			checkInId,
			monitorSlug: 'notification-cron',
			status: 'ok'
		});
	} catch (e) {
		Sentry.captureCheckIn({
			checkInId,
			monitorSlug: 'notification-cron',
			status: 'error'
		});
	}

	const templates = await db.select().from(courseTemplateTable).where(eq(courseTemplateTable.autoCreate, true));
	for (const template of templates) {
		try {
			await autoCreateCourseTemplate(db, template);
		} catch (e) {
			console.error(e);
		}
	}

	return new Response(JSON.stringify({ message: 'ok' }));
};

async function autoCreateCourseTemplate(db: DB, template: CourseTemplate) {
	const now = new Date();
	const start = startOfWeek(now);
	const end = endOfWeek(now);

	const [c] = await db
		.select()
		.from(courses)
		.where(and(lt(courses.publishOn, end), gt(courses.publishOn, start), eq(courses.fromTemplate, template.id)));

	// If a course already exists for this week, return
	if (c) {
		return;
	}

	const hydrated = hydrateCourseTemplate(template, null, null);

	// create course from template
	const [course] = await db
		.insert(courses)
		.values({
			...template,
			date: hydrated.date!,
			publishOn: hydrated.publishOn!,
			createdAt: new Date().toISOString(),
			updatedAt: new Date().toISOString(),
			fromTemplate: template.id
		} satisfies typeof courses.$inferInsert)
		.returning();

	// auto assign trainer
	if (template.trainer) {
		const [trainer] = await db.select().from(accounts).where(eq(accounts.id, template.trainer)).limit(1);

		if (!trainer) {
			return;
		}

		await db.insert(courseSpots).values({
			courseId: course.id,
			userId: template.trainer,
			createdAt: new Date(),
			deletedAt: null
		});

		await sendEmail(AutoCreatedNotification, {
			user: trainer,
			subject: `Your course has been created`,
			props: { course, user: trainer }
		});
	}
}
