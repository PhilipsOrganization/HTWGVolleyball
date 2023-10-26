// @ts-nocheck
import { Course } from '@lib/database';
import { redirect } from '@sveltejs/kit';
import type { PageServerLoad } from './$types';

export const load = async ({ locals }: Parameters<PageServerLoad>[0]) => {
	if (locals.user) {
		throw redirect(303, '/courses');
	}
	throw redirect(303, '/login');

	// const courses = await locals.em.find(
	// 	Course,
	// 	{ publishOn: { $lt: new Date() } },
	// 	{ orderBy: { date: 'ASC' } }
	// );

	// const dates: { [date: string]: Course[] } = {};

	// for (const course of courses) {
	// 	const date = course.date.toISOString().substr(0, 10);
	// 	if (!dates[date]) {
	// 		dates[date] = [];
	// 	}
	// 	dates[date].push(course);
	// }

	// return {
	// 	dates: Object.entries(dates).map(([date, courses]) => ({
	// 		date,
	// 		courses: courses.map((c) => c.toJSON())
	// 	}))
	// };
};
