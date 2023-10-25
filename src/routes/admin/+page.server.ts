import { redirect, type Actions, error, fail } from '@sveltejs/kit';
import type { PageServerLoad } from './$types';
import { Course } from '$lib/db/entities';
import { Role } from '$lib/db/role';
import { assign } from '@mikro-orm/core';
import { User } from '$lib/db/entities';
import { z } from 'zod';
import { startOfYesterday } from 'date-fns';

export const load: PageServerLoad = async ({ locals, url }) => {
	if (!locals.user || locals.user.role === Role.USER) {
		throw redirect(303, '/courses');
	}

	// find all courses that take place in the future
	const showArchived = url.searchParams.has('archived');
	const courses = await locals.em.find(Course, showArchived ? {} : { date: { $gte: startOfYesterday() } });

	const dates: { [date: string]: Course[] } = {};

	for (const course of courses) {
		const date = course.date.toISOString().substr(0, 10);
		if (!dates[date]) {
			dates[date] = [];
		}
		dates[date].push(course);
	}

	const users = await locals.em.find(User, {});
	let course: Course | null = null;

	if (url.searchParams.has('course')) {
		const courseId = parseInt(url.searchParams.get('course') ?? '');
		course = await locals.em.findOne(Course, { id: courseId });
	}

	return {
		users: users.map((u: User) => u.toJSON()),
		dates: Object.entries(dates).map(([date, courses]) => ({
			date,
			courses: courses.map((c) => c.toJSON(locals.user))
		})),
		user: locals.user.toJSON(),
		course: course?.toJSON(locals.user)
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
	publishOn: z.string().length('YYYY-MM-DDTHH:MM'.length)
});

export const actions = {
	'create-course': async ({ locals, request }) => {
		if (!locals.user || locals.user.role === Role.USER) {
			throw redirect(303, '/login');
		}

		const form = await request.formData();
		let dto: z.infer<typeof courseValidation>;
		try {
			dto = courseValidation.parse(Object.fromEntries(form.entries()));
		} catch (e) {
			const error = e as z.ZodError;
			const obj: Record<string, string> = {};

			for (const issue of error.issues) {
				obj[issue.path.join('.')] = issue.message;
			}

			return fail(400, obj);
		}

		const data = {
			...dto,
			date: new Date(dto.date),
			publishOn: new Date(dto.publishOn),
			maxParticipants: parseInt(dto.maxParticipants)
		};

		const course = new Course();
		assign(course, data);

		await locals.em.persistAndFlush(course);

		return;
	},

	'update-course': async ({ locals, request }) => {
		if (!locals.user || locals.user.role === Role.USER) {
			throw redirect(303, '/login');
		}

		const form = await request.formData();
		const courseIdString = form.get('courseId') as string | undefined;
		const name = form.get('title') as string | undefined;
		if (!courseIdString || !name) {
			throw error(400, 'No courseId or title provided');
		}

		const courseId = parseInt(courseIdString);
		const course = await locals.em.findOne(Course, { id: courseId });
		if (!course) {
			throw error(400, 'Course not found');
		}

		assign(course, { name });
		await locals.em.persistAndFlush(course);
	},
	demote: async ({ locals, params }) => {
		if (!locals.user || locals.user.role === Role.USER) {
			throw redirect(303, '/login');
		}

		const userIdString = params.id as string | undefined;
		if (!userIdString) {
			throw error(400, 'No userId provided');
		}

		const userId = parseInt(userIdString);
		const user = await locals.em.findOne(User, { id: userId });

		if (!user) {
			throw error(400, 'User not found');
		}

		if (user.role === Role.SUPER_ADMIN) {
			throw error(400, 'Cannot demote super admin');
		}

		user.role = Role.USER;
		await locals.em.persistAndFlush(user);
	},

	promote: async ({ locals, params }) => {
		if (locals.user?.role !== Role.ADMIN && locals.user?.role !== Role.SUPER_ADMIN) {
			throw redirect(303, '/login');
		}

		const userIdString = params.id as string | undefined;
		if (!userIdString) {
			throw error(400, 'No userId provided');
		}

		const userId = parseInt(userIdString);
		const user = await locals.em.findOne(User, { id: userId });
		if (!user) {
			throw error(400, 'User not found');
		}

		if (user.role === Role.SUPER_ADMIN) {
			throw error(400, 'Cannot promote super admin');
		}

		user.role = Role.USER;
		await locals.em.persistAndFlush(user);
	}
} satisfies Actions;
