import { error, redirect } from '@sveltejs/kit';
import type { PageServerLoad } from './$types';
import { Course } from '$lib/db/entities/course';
import { Role } from '$lib/db/role';

export const load: PageServerLoad = async ({ locals }) => {
	if (!locals.user) {
		throw redirect(303, '/login');
	}

	const isAdmin = locals.user.role !== Role.USER;

	const courses = await locals.em.find(Course, isAdmin ? {} : { publishOn: { $lt: new Date() } }, {
		orderBy: { date: 'ASC' }
	});

	const dates: { [date: string]: Course[] } = {};

	for (const course of courses) {
		const date = course.date.toISOString().substr(0, 10);
		if (!dates[date]) {
			dates[date] = [];
		}
		dates[date].push(course);
	}

	return {
		courses: locals.user.courses.getItems().map((c) => c.toJSON()),
		dates: Object.entries(dates).map(([date, courses]) => ({
			date,
			courses: courses.map((c) => c.toJSON(locals.user))
		})),
		user: locals.user.toJSON()
	};
};

export const actions = {
	enlist: async ({ locals, request }) => {
		if (!locals.user) {
			throw redirect(303, '/login');
		}

		const form = await request.formData();
		const courseIdString = form.get('courseId') as string | undefined;
		if (!courseIdString) {
			throw error(400, 'No courseId provided');
		}

		const courseId = parseInt(courseIdString);
		const course = await locals.em.findOne(Course, { id: courseId });
		if (!course) {
			throw error(400, 'Course not found');
		}

		if (locals.user.courses.contains(course)) {
			throw error(400, 'Already enrolled');
		}

		locals.user.courses.add(course);
		course.users.add(locals.user);

		await locals.em.persistAndFlush([locals.user, course]);
	},
	drop: async ({ locals, request }) => {
		if (!locals.user) {
			throw redirect(303, '/login');
		}

		const form = await request.formData();
		const courseIdString = form.get('courseId') as string | undefined;
		if (!courseIdString) {
			throw error(400, 'No courseId provided');
		}

		const courseId = parseInt(courseIdString);
		const course = await locals.em.findOne(Course, { id: courseId });
		if (!course) {
			throw error(400, 'Course not found');
		}

		if (!locals.user.courses.contains(course)) {
			throw error(400, 'Not enrolled');
		}

		locals.user.courses.remove(course);
		course.users.remove(locals.user);
		await locals.em.persistAndFlush([locals.user, course]);
	}
};
