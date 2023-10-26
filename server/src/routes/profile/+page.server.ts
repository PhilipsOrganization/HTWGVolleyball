import { getPath } from '$lib/helpers/stats';
import { Course, RegistrationStats, UserStats } from '@lib/database';
import { redirect } from '@sveltejs/kit';
import type { PageServerLoad } from '../$types';

export const load: PageServerLoad = async ({ locals }) => {
	if (!locals.user) {
		throw redirect(303, '/login');
	}

	const stats = await locals.em.find(UserStats, { userId: locals.user.id });
	const registrationStats = await locals.em.findOne(RegistrationStats, { userId: locals.user.id });
	const totalRegistrations = await locals.em.find(
		Course,
		{ users: locals.user },
		{ populate: [], fields: ['date'], orderBy: { date: 'ASC' } }
	);

	return {
		user: locals.user.toJSON(),
		stats: stats.map((s) => s.toJSON()),
		registrationStats: registrationStats?.toJSON(),
		totalRegistrations: totalRegistrations.length,
		svg: getPath(totalRegistrations)
	};
};
