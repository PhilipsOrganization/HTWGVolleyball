import { User } from '$lib/db/entities';
import { type Actions, redirect, fail } from '@sveltejs/kit';
import type { PageServerLoad } from '../$types';
import { env } from '$env/dynamic/private';

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
			return fail(400, { missingCredentials: true });
		}

		// login with username or email
		const user = await locals.em.findOne(User, { $or: [{ username }, { email: username.toLowerCase() }] });

		if (!user) {
			return fail(400, { username, userNotFound: true });
		}

		const correct = await user.isPasswordCorrect(password);
		if (!correct) {
			return fail(400, { username, wrongPassword: true });
		}

		const sessionToken = Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
		user.sessionToken = sessionToken;
		await locals.em.persistAndFlush(user);

		cookies.set('user', sessionToken, { path: '/' });

		throw redirect(303, '/courses');
	},
	authenticate: async () => {
		const googleEndpoint = "https://accounts.google.com/o/oauth2/v2/auth";
		const client = env.VITE_GOOGLE_CLIENT_ID;
		const redirectUrl = 'https://volleyball.oesterlin.dev/authorize';

		const scopes = [
			"https://www.googleapis.com/auth/userinfo.email",
			"https://www.googleapis.com/auth/userinfo.profile"
		];

		const state = Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
		const nonce = Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);

		const url = new URL(googleEndpoint);
		url.searchParams.set("client_id", client);
		url.searchParams.set("redirect_uri", redirectUrl);
		url.searchParams.set("response_type", "code");
		url.searchParams.set("scope", scopes.join(" "));
		url.searchParams.set("state", state);
		url.searchParams.set("nonce", nonce);

		throw redirect(303, url.toString());
	}
} satisfies Actions;
