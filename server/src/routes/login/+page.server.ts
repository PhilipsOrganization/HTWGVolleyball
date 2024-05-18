import { env } from '$env/dynamic/private';
import { accounts } from '$lib/db/schema.js';
import { findOneByNameOrEmail, generateRandomToken, isPasswordCorrect } from '$lib/helpers/account.js';
import { fail, redirect, type Actions } from '@sveltejs/kit';
import { eq } from 'drizzle-orm';
import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ locals }) => {
	if (locals.user) {
		redirect(303, '/courses');
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

		const user = await findOneByNameOrEmail(username, locals.db);
		if (!user) {
			return fail(400, { username, userNotFound: true });
		}

		const correct = await isPasswordCorrect(user, password);
		if (!correct) {
			return fail(400, { username, wrongPassword: true });
		}

		const sessionToken = generateRandomToken();
		await locals.db
			.update(accounts)
			.set({ lastLogin: new Date().toISOString(), sessionToken })
			.where(eq(accounts.id, user.id));

		const expirationDate = new Date(Date.now() + 1000 * 60 * 60 * 24 * 21);
		cookies.set('user', sessionToken, { path: '/', expires: expirationDate });

		redirect(303, '/courses');
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

		redirect(303, url.toString());
	},
} satisfies Actions;
