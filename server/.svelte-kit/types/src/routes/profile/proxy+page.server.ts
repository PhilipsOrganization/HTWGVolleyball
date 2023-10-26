// @ts-nocheck
import { Course, UserStats } from '@lib/database';
import { getPath } from '$lib/helpers/stats';
import { redirect } from '@sveltejs/kit';
import type { PageServerLoad } from '../$types';
import { RegistrationStats } from '@lib/database/registration-stats';

export const load = async ({ locals }: Parameters<PageServerLoad>[0]) => {
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
