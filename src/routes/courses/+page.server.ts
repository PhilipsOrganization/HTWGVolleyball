import { redirect } from '@sveltejs/kit';
import type { PageServerLoad } from './$types';
import { Course } from '$lib/db/entities';
import { Role } from '$lib/db/role';
import { startOfYesterday } from 'date-fns';

export const load: PageServerLoad = async ({ locals }) => {
	if (!locals.user) {
		throw redirect(303, '/login');
	}

	const isAdmin = locals.user.role !== Role.USER;
	const baseQuery = { date: { $gte: startOfYesterday() } };
	const courses = await locals.em.find(Course, isAdmin ? baseQuery : { publishOn: { $lt: new Date() }, ...baseQuery }, {
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
