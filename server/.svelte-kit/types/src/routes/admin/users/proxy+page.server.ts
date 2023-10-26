// @ts-nocheck
import { User } from '@lib/database';
import { Role } from '@lib/database';
import { redirect } from '@sveltejs/kit';
import type { PageServerLoad } from './$types';

export const load = async ({ locals }: Parameters<PageServerLoad>[0]) => {
	if (!locals.user || locals.user.role === Role.USER) {
		throw redirect(303, '/courses');
	}

	const users = await locals.em.find(User, {});

	return {
		users: users.map((u) => u.toJSON()),
		user: locals.user.toJSON()
	};
};
