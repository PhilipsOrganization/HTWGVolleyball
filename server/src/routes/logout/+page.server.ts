import { redirect } from '@sveltejs/kit';
import type { PageServerLoad } from './$types';
import { accounts } from '$lib/db/schema.js';
import { eq } from 'drizzle-orm';
import { generateRandomToken } from '$lib/helpers/account';

export const load: PageServerLoad = async ({ cookies, locals }) => {
	cookies.delete('user', { path: '/' });

	if (locals.user) {
		await locals.db
			.update(accounts)
			.set({ sessionToken: generateRandomToken() })
			.where(eq(accounts.id, locals.user.id));
	}


	redirect(300, '/login');
};
