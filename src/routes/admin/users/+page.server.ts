import { User } from '$lib/db/entities';
import { Role } from '$lib/db/role';
import { error, redirect, type Actions } from '@sveltejs/kit';
import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ locals }) => {
	if (!locals.user || locals.user.role === Role.USER) {
		throw redirect(303, '/courses');
	}

	const users = await locals.em.find(User, {});

	return {
		users: users.map((u) => u.toJSON()),
		user: locals.user.toJSON()
	};
};

export const actions = {
	demote: async ({ locals, request }) => {
		if (!locals.user || locals.user.role === Role.USER) {
			throw redirect(303, '/login');
		}

		const form = await request.formData();
		const userIdString = form.get('userId') as string | undefined;
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

	promote: async ({ locals, request }) => {
		if (locals.user?.role !== Role.ADMIN && locals.user?.role !== Role.SUPER_ADMIN) {
			throw redirect(303, '/login');
		}

		const form = await request.formData();
		const userIdString = form.get('userId') as string | undefined;
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
