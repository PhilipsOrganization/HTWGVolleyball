import { User } from '$lib/db/entities';
import { Role } from '$lib/db/role';
import { redirect } from '@sveltejs/kit';
import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ locals }) => {
	if (!locals.user || locals.user.role === Role.USER) {
		redirect(303, '/courses');
	}

	const users = await locals.em.find(User, {}, { orderBy: { role: 'ASC', username: 'ASC' } });

	return {
		users: users.map((u) => u.toJSON()),
		user: locals.user.toJSON()
	};
};
