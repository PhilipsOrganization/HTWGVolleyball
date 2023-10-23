import { User } from '$lib/db/entities';
import { error, type Actions, redirect } from '@sveltejs/kit';
import type { PageServerLoad } from '../$types';

export const load: PageServerLoad = async ({ locals }) => {
	if (locals.user) {
		throw redirect(303, '/courses');
	}
};

export const actions = {
	login: async ({ locals, request, cookies }) => {
		const form = await request.formData();

		const username = form.get('username') as string | undefined;
		const password = form.get('password') as string | undefined;

		if (!username || !password) {
			throw error(400, 'No username or password provided');
		}

		const user = await locals.em.findOne(User, { username });
		if (!user) {
			throw error(400, 'User not found');
		}

		if (!user.isPasswordCorrect(password)) {
			throw error(400, 'Incorrect password');
		}

		const sessionToken = Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
		user.sessionToken = sessionToken;
		await locals.em.persistAndFlush(user);
		
		cookies.set('user', sessionToken, { path: '/' });

		throw redirect(303, '/courses');
	}
} satisfies Actions;
