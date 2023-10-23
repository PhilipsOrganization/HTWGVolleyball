import { Course, UserStats } from '$lib/db/entities';
import { getPath } from '$lib/helpers/stats';
import { redirect } from '@sveltejs/kit';
import type { PageServerLoad } from '../$types';
import { RegistrationStats } from '$lib/db/entities/registration-stats';

export const load: PageServerLoad = async ({ locals }) => {
	if (!locals.user) {
		throw redirect(303, '/login');
	}

	const stats = await locals.em.find(UserStats, { userId: locals.user.id });
	const registrationStats = await locals.em.findOne(RegistrationStats, { userId: locals.user.id });
	const testStats = await locals.em.find(RegistrationStats, {});
	console.log({ testStats });

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
