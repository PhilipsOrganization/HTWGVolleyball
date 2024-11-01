import { accounts, courseSpots, courses, type Account } from '$lib/db/schema.js';
import { serializeUser } from '$lib/helpers/account';
import { serializeCourse } from '$lib/helpers/course';
import { and, eq, gte, lte, sql } from 'drizzle-orm';
import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ locals }) => {
	const result = await locals.db
		.select({
			courses,
			accountsJson: sql<Account[]>`json_agg(accounts order by ${courseSpots.createdAt} asc)`.as('accountsJson')
		})
		.from(courseSpots)
		.fullJoin(courses, eq(courseSpots.courseId, courses.id))
		.fullJoin(accounts, eq(courseSpots.userId, accounts.id))
		.groupBy(courses.id)
		.where(
			and(
				lte(courses.publishOn, sql`NOW()`), // Only show courses that have been published
				gte(courses.date, sql`NOW() - INTERVAL '1 day'`) // Only show courses that are 24 hours in the past
			)
		)
		.orderBy(courses.date, courses.time);

	const dates = new Map<string, typeof result>();

	for (const course of result) {
		if (!course.courses) {
			continue;
		}

		const date = new Date(course.courses.date).toISOString().substring(0, 10);

		const courses = dates.get(date) ?? [];
		courses.push(course);
		dates.set(date, courses);
	}

	return {
		dates: Array.from(dates).map(([date, courses]) => ({
			date,
			courses: courses.map((data) => serializeCourse(data, locals.user))
		})),
		user: locals.user ? serializeUser(locals.user) : undefined
	};
};
