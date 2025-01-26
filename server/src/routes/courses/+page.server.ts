import { accounts, courseSpots, courses, groupMembers, groups, type Account, type Course } from '$lib/db/schema.js';
import { serializeUser } from '$lib/helpers/account';
import { serializeCourse } from '$lib/helpers/course';
import { and, eq, gte, inArray, isNull, lte, or, sql } from 'drizzle-orm';
import type { PageServerLoad } from './$types';
import { redirect } from '@sveltejs/kit';
import { Role } from '$lib/db/role';

export const load: PageServerLoad = async ({ locals }) => {
	if (!locals.user) {
		redirect(303, '/login');
	}

	const { db } = locals;

	let memberships: { id: number | null }[] = [];

	if (locals.user.role === Role.USER) {
		memberships = await db
			.select({
				id: groups.id
			})
			.from(groupMembers)
			.where(eq(groupMembers.userId, locals.user.id))
			.leftJoin(groups, eq(groupMembers.groupId, groups.id));
	} else {
		memberships = await db
			.select({
				id: groups.id
			})
			.from(groups);
	}

	const result = await db
		.select({
			courses,
			accountsJson: sql<Account[]>`json_agg(
				json_build_object(
					'id', ${accounts.id},
					'username', ${accounts.username},
					'role', ${accounts.role},
					'canceledAt', ${courseSpots.deletedAt}
				)
			 order by ${courseSpots.createdAt} asc)`.as('accountsJson')
		})
		.from(courseSpots)
		.fullJoin(courses, eq(courseSpots.courseId, courses.id))
		.fullJoin(accounts, eq(courseSpots.userId, accounts.id))
		.groupBy(courses.id)
		.where(
			and(
				isNull(courses.deletedAt),
				lte(courses.publishOn, sql`NOW()`), // Only show courses that have been published
				gte(courses.date, sql`NOW() - INTERVAL '1 day'`), // Only show courses that are 24 hours in the past
				or(
					isNull(courses.groupId), // Show courses that are not in a group
					inArray(
						// Show courses that are in a group that the user is a member of
						courses.groupId,
						memberships.map((m) => m.id).filter((id) => id !== null)
					)
				)
			)
		)
		.orderBy(courses.date, courses.time);

	const dates = new Map<string, typeof result>();

	for (const course of result) {
		if (!course.courses || course.courses.deletedAt) {
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
			courses: courses
				.filter((data) => Boolean(data.courses))
				.map((data) => serializeCourse(data.courses as Course, data.accountsJson, locals.user))
		})),
		globalUser: serializeUser(locals.user)
	};
};
