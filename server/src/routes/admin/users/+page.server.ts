import { Role } from '$lib/db/role';
import { accounts } from '$lib/db/schema';
import { sanitizeUser, serializeUser } from '$lib/helpers/account';
import { redirect } from '@sveltejs/kit';
import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ locals }) => {
	if (!locals.user || locals.user.role === Role.USER) {
		redirect(303, '/courses');
	}

	const users = await locals.db.select().from(accounts).orderBy(accounts.role, accounts.username);
	return {
		users: users.map((u) => sanitizeUser(u)),
		globalUser: serializeUser(locals.user)
	};
};
