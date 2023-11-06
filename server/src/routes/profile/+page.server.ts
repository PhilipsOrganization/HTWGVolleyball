import { Course, UserStats } from '$lib/db/entities';
import { getPath } from '$lib/helpers/stats';
import { redirect, type Actions } from '@sveltejs/kit';
import type { PageServerLoad } from '../$types';
import { RegistrationStats } from '$lib/db/entities/registration-stats';
import { sendEmail } from '$lib/email';
import ConfirmEmail from '$lib/email/templates/confirm-email.svelte';

export const load: PageServerLoad = async ({ locals }) => {
	if (!locals.user) {
		throw redirect(303, '/login');
	}

	const stats = await locals.em.find(UserStats, { userId: locals.user.id });
	const registrationStats = await locals.em.findOne(RegistrationStats, { userId: locals.user.id });
	const totalRegistrations = await locals.em.find(
		Course,
		{ users: locals.user },
		{ populate: [], fields: ['date'], orderBy: { date: 'ASC' } }
	);

	return {
		user: locals.user.toJSON(),
		stats: stats.map((s) => s.toJSON()),
		registrationStats: registrationStats?.toJSON(),
		totalRegistrations: totalRegistrations.length,
		svg: getPath(totalRegistrations)
	};
};

export const actions = {
	reverify: async ({ locals }) => {
		const user = locals.user;
		if (!user) {
			throw redirect(303, '/login');
		}

		// token is used to verify the email
		const token = Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
		user.emailVerificationToken = token;
		await locals.em.persistAndFlush(user);

		await sendEmail(ConfirmEmail, { user, subject: 'Confirm your Email', props: { user: locals.user, token } });
	}
} satisfies Actions;
