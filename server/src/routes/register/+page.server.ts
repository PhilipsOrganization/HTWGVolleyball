import { User } from '$lib/db/entities';
import { Role } from '$lib/db/role';
import { sendEmail } from '$lib/email';
import ConfirmEmail from '$lib/email/templates/confirm-email.svelte';
import { fail, redirect, type Actions } from '@sveltejs/kit';

export const actions = {
	register: async ({ locals, request, cookies }) => {
		const form = await request.formData();

		let username = form.get('username') as string | undefined;
		const password = form.get('password') as string | undefined;
		let email = form.get('email') as string | undefined;

		if (!username || !password || !email) {
			return fail(400, { username, email, missingCredentials: true });
		}

		username = username.trim();
		const invalidUsername = username.length < 5 || !username.includes(' ');
		if (invalidUsername) {
			return fail(400, { username, email, invalidUsername: true });
		}

		const invalidEmail = !email.includes('@');
		if (invalidEmail) {
			return fail(400, { username, email, invalidEmail: true });
		}

		const weakPassword = password.length < 8;
		if (weakPassword) {
			return fail(400, { username, email, weakPassword: true });
		}

		email = email.toLowerCase();

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
		const expirationDate = new Date(Date.now() + 1000 * 60 * 60 * 24 * 21);
		cookies.set('user', newUser.sessionToken, { path: '/', expires: expirationDate });

		// token is used to verify the email
		const token = Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
		newUser.emailVerificationToken = token;

		console.log('Creating new user', newUser);

		const user = locals.em.create(User, newUser);
		await locals.em.persistAndFlush(user);

		await sendEmail(ConfirmEmail, { user, subject: 'Confirm your Email', props: { user, token } });

		redirect(303, '/courses'); // 307 is a temporary redirect, 301 is permanent
	}
} satisfies Actions;
