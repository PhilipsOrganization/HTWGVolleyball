import { Role } from '$lib/db/role.js';
import { accounts, type Account } from '$lib/db/schema.js';
import { sendEmail } from '$lib/email/index.js';
import ConfirmEmail from '$lib/email/templates/confirm-email.svelte';
import { generateRandomToken, hashPassword } from '$lib/helpers/account.js';
import { fail, redirect, type Actions } from '@sveltejs/kit';
import { count, eq, or } from 'drizzle-orm';

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

		const [existingUser] = await locals.db.select().from(accounts).where(
			or(
				eq(accounts.username, username),
				eq(accounts.email, email)
			)
		).limit(1);

		if (existingUser) {
			return fail(400, { username, email, userAlreadyExists: true });
		}

		const newUser = {
			username,
			password: await hashPassword(password),
			email,
			role: Role.USER,
			sessionToken: generateRandomToken(),
			emailVerificationToken: generateRandomToken(),
			strikes: 0,
		} satisfies typeof accounts.$inferInsert;

		const [userCount] = await locals.db.select({ count: count() }).from(accounts);
		if (userCount.count === 0) {
			newUser.role = Role.SUPER_ADMIN;
		}

		const expirationDate = new Date(Date.now() + 1000 * 60 * 60 * 24 * 21);
		cookies.set('user', newUser.sessionToken, { path: '/', expires: expirationDate });

		// token is used to verify the email
		console.log('Creating new user', newUser);

		const [user] = await locals.db.insert(accounts).values(newUser).returning();
		await sendEmail(ConfirmEmail, { user, subject: 'Confirm your Email', props: { user, token: user.emailVerificationToken } });

		redirect(303, '/courses'); // 307 is a temporary redirect, 301 is permanent
	}
} satisfies Actions;
