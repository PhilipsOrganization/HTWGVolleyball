import { UserStats } from '$lib/db/entities/user-stats';
import { Role } from '$lib/db/role';
import { redirect } from '@sveltejs/kit';
import type { PageServerLoad } from './$types';
import { Course, User } from '$lib/db/entities';
import { getPath } from '$lib/helpers/stats';

export const load: PageServerLoad = async ({ locals, params }) => {
	if (!locals.user || locals.user.role === Role.USER) {
		throw redirect(303, '/courses');
	}

	const user = await locals.em.findOneOrFail(User, { id: parseInt(params.id) });
	const stats = await locals.em.find(UserStats, { userId: parseInt(params.id) });
	const totalRegistrations = await locals.em.find(
		Course,
		{ users: user },
		{ populate: [], fields: ['date'], orderBy: { date: 'ASC' } }
	);

	return {
		user: user.toJSON(),
		stats: stats.map((s) => s.toJSON()),
		totalRegistrations: totalRegistrations.length,
		svg: getPath(totalRegistrations)
	};
};
