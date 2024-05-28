import { accounts, courseSpots, courses } from '$lib/db/schema.js';
import { sendEmail } from '$lib/email';
import ConfirmEmail from '$lib/email/templates/confirm-email.svelte';
import { generateRandomToken, serializeUser } from '$lib/helpers/account.js';
import { redirect, type Actions } from '@sveltejs/kit';
import { count, eq, sql } from 'drizzle-orm';
import type { PageServerLoad } from './$types.js';

export const load: PageServerLoad = async ({ locals }) => {
	if (!locals.user) {
		redirect(303, '/login');
	}

	const stats = await locals.db
		.select({ name: courses.name, count: count() })
		.from(courseSpots)
		.leftJoin(courses, eq(courseSpots.courseId, courses.id))
		.where(eq(courseSpots.userId, locals.user.id))
		.groupBy(courses.name)
		.limit(10);

	const timeDiff = sql`extract(epoch from ${courseSpots.createdAt}) - extract(epoch from ${courses.publishOn})`;
	const [registrationStats] = await locals.db
		.select({
			avg: sql<number>`avg(${timeDiff})`.as('avg'),
			min: sql<number>`min(${timeDiff})`.as('min')
		})
		.from(courseSpots)
		.leftJoin(courses, eq(courseSpots.courseId, courses.id))
		.where(eq(courseSpots.userId, locals.user.id))
		.groupBy(courseSpots.userId)
		.limit(1);

	const [totalRegistrations] = await locals.db
		.select({ count: count() })
		.from(courseSpots)
		.where(eq(courseSpots.userId, locals.user.id))
		.limit(1);

	return {
		user: serializeUser(locals.user),
		stats,
		registrationStats,
		totalRegistrations: totalRegistrations.count
		// svg: getPath(totalRegistrations)
	};
};

export const actions = {
	reverify: async ({ locals }) => {
		const user = locals.user;
		if (!user) {
			redirect(303, '/login');
		}

		const token = generateRandomToken();
		await locals.db.update(accounts).set({ emailVerificationToken: token }).where(eq(accounts.id, user.id));

		await sendEmail(ConfirmEmail, { user, subject: 'Confirm your Email', props: { user: locals.user, token } });
	}
} satisfies Actions;
