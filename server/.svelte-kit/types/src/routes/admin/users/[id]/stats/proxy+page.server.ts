// @ts-nocheck
import { Course, Role, User, UserStats } from '$lib/db';
import { getPath } from '$lib/helpers/stats';
import { error, redirect, type Actions } from '@sveltejs/kit';
import type { PageServerLoad } from './$types';

export const load = async ({ locals, params }: Parameters<PageServerLoad>[0]) => {
	if (!locals.user || locals.user.role === Role.USER) {
		throw redirect(303, '/courses');
	}

	const user = await locals.em.findOneOrFail(User, { id: parseInt(params.id) });
	const stats = await locals.em.find(UserStats, { userId: parseInt(params.id) });
	const totalRegistrations = await locals.em.find(Course, { users: user }, { populate: [], fields: ['date'], orderBy: { date: 'ASC' } });

	return {
		user: user.toJSON(),
		stats: stats.map((s) => s.toJSON()),
		totalRegistrations: totalRegistrations.length,
		svg: getPath(totalRegistrations)
	};
};

export const actions = {
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
		user.sessionToken = undefined;
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

		user.role = Role.ADMIN;
		user.sessionToken = undefined;
		await locals.em.persistAndFlush(user);
	}
} satisfies Actions;
