import { Role } from '$lib/db/role';
import { accounts, courseSpots, courseTemplateTable, courses, groups, type Account, type Course } from '$lib/db/schema';
import { serializeUser } from '$lib/helpers/account';
import { serializeCourse } from '$lib/helpers/course';
import { fail, redirect, type Actions } from '@sveltejs/kit';
import { startOfYesterday } from 'date-fns';
import { zonedTimeToUtc } from 'date-fns-tz';
import { and, desc, eq, gte, is, isNull, sql } from 'drizzle-orm';
import { z } from 'zod';
import type { PageServerLoad } from './$types';
import { hydrateCourseTemplate } from '$lib/helpers/courseTemplate';

export const load: PageServerLoad = async ({ locals, url }) => {
	if (!locals.user || locals.user.role === Role.USER) {
		redirect(303, '/courses');
	}

	const baseQuery = isNull(courses.deletedAt);
	const showArchived = url.searchParams.has('archived');
	const dateQuery = showArchived ? baseQuery : and(baseQuery, gte(courses.date, startOfYesterday()));

	const result = await locals.db
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
		.where(dateQuery)
		.orderBy(desc(courses.date), courses.time);

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

	const g = await locals.db.select().from(groups).orderBy(groups.name);

	const courseTemplates = await locals.db
		.select()
		.from(courseTemplateTable)
		.leftJoin(groups, eq(courseTemplateTable.groupId, groups.id))
		.leftJoin(accounts, eq(courseTemplateTable.trainer, accounts.id))
		.orderBy(courseTemplateTable.day, courseTemplateTable.time);

	return {
		dates: Array.from(dates).map(([date, courses]) => ({
			date,
			courses: courses
				.filter((data) => Boolean(data.courses))
				.map((data) => serializeCourse(data.courses as Course, data.accountsJson, locals.user))
		})),
		globalUser: serializeUser(locals.user),
		groups: g,
		courseTemplates: courseTemplates.map(({ course_template, groups, accounts }) =>
			hydrateCourseTemplate(course_template, groups, accounts)
		)
	};
};

const courseValidation = z.object({
	name: z.string().min(3).max(100),
	location: z.string().min(3).max(100),
	date: z.string().length('YYYY-MM-DD'.length),
	time: z
		.string()
		.length('HH:MM'.length)
		.regex(/^\d\d:\d\d$/),
	maxParticipants: z.string().min(1).max(3).regex(/^\d+$/),
	publishOn: z.string().length('YYYY-MM-DDTHH:MM'.length),
	allowDoubleBookings: z.coerce
		.string()
		.default('off')
		.transform((v) => v === 'on'),
	groupId: z.coerce.number().optional(),
	maxStrikes: z.number().int().min(0).max(100).default(0)
});

export const actions = {
	'create-course': async ({ locals, request }) => {
		if (!locals.user || locals.user.role === Role.USER) {
			redirect(303, '/login');
		}

		const form = await request.formData();
		const dto = courseValidation.safeParse(Object.fromEntries(form));

		if (!dto.success) {
			const obj: Record<string, string> = {};

			for (const issue of dto.error.issues) {
				obj[issue.path.join('.')] = issue.message;
			}

			return fail(400, obj);
		}

		const course = dto.data;
		const publishOn = new Date(course.publishOn);

		if (course.groupId) {
			const [g] = await locals.db.select().from(groups).where(eq(groups.id, course.groupId)).limit(1);

			if (!g) {
				return fail(400, { groupId: 'Group not found' });
			}
		} else {
			course.groupId = undefined;
		}

		await locals.db.insert(courses).values({
			...course,
			date: new Date(course.date),
			publishOn: zonedTimeToUtc(publishOn, 'Europe/Berlin'),
			maxParticipants: parseInt(course.maxParticipants),
			createdAt: new Date().toISOString(),
			updatedAt: new Date().toISOString()
		} satisfies typeof courses.$inferInsert);
	}
} satisfies Actions;
