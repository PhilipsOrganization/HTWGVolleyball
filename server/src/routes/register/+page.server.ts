import { User } from '$lib/db/entities';
import { Role } from '$lib/db/role';
import { fail, redirect, type Actions } from '@sveltejs/kit';

export const actions = {
	register: async ({ locals, request, cookies }) => {
		const form = await request.formData();

		const username = form.get('username') as string | undefined;
		const password = form.get('password') as string | undefined;
		const email = form.get('email') as string | undefined;

		if (!username || !password || !email) {
			return fail(400, { username, email, missingCredentials: true });
		}

		const weakPassword = password.length < 8;
		if (weakPassword) {
			return fail(400, { username, email, weakPassword: true });
		}

		const existingUser = await locals.em.findOne(User, { $or: [{ username }, { email }] });
		if (existingUser) {
			return fail(400, { username, email, userAlreadyExists: true });
		}

		const hash = await User.hashPassword(password);
		const newUser = new User(username, email, hash);

		const isFirstUser = (await locals.em.count(User)) === 0;
		if (isFirstUser) {
			newUser.role = Role.SUPER_ADMIN;
		}

		const sessionToken = Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
		newUser.sessionToken = sessionToken;
		cookies.set('user', newUser.sessionToken, { path: '/' });

		const user = locals.em.create(User, newUser);
		await locals.em.persistAndFlush(user);
		throw redirect(303, '/courses'); // 307 is a temporary redirect, 301 is permanent
	}
} satisfies Actions;
