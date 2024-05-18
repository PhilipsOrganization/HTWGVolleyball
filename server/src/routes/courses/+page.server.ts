import { accounts, courseSpots, courses, type Account } from '$lib/db/schema.js';
import { serializeUser } from '$lib/helpers/account';
import { serializeCourse } from '$lib/helpers/course';
import { redirect } from '@sveltejs/kit';
import { eq, sql } from 'drizzle-orm';
import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ locals }) => {
	if (!locals.user) {
		redirect(303, '/login');
	}

	const result = await locals.db
		.select({
			courses,
			accountsJson: sql<Account[]>`json_agg(accounts order by course_spots.created_at asc)`.as('accountsJson'),
		})
		.from(courseSpots)
		.leftJoin(courses, eq(courseSpots.courseId, courses.id))
		.leftJoin(accounts, eq(courseSpots.userId, accounts.id))
		.groupBy(courses.id)
		.where(eq(sql<boolean>`(publish_on <= NOW() AND date >= (NOW() - INTERVAL '1 day'))`, true))
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
		user: serializeUser(locals.user)
	};
};
