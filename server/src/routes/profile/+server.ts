import { OpenAppAction, OpenProfileAction, sendNotification } from '$lib/helpers/notification';
import { redirect } from '@sveltejs/kit';
import { z } from 'zod';
import type { RequestHandler } from './$types';
import { eq } from 'drizzle-orm';
import { accounts } from '$lib/db/schema';
import { serializeUser } from '$lib/helpers/account';

export const POST: RequestHandler = async ({ request, locals }) => {
	if (!locals.user) {
		redirect(303, '/login');
	}

	const body = (await request.json()) as unknown;
	const safeSubscription = z
		.object({
			subscription: z.object({
				endpoint: z.string(),
				expirationTime: z.union([z.string(), z.undefined(), z.null()]),
				keys: z.object({
					p256dh: z.string(),
					auth: z.string()
				})
			})
		})
		.parse(body);

	await locals.db
		.update(accounts)
		.set({
			subscriptionAuth: safeSubscription.subscription.keys.auth,
			subscriptionP256Dh: safeSubscription.subscription.keys.p256dh,
			subscriptionEndpoint: safeSubscription.subscription.endpoint,
			subscriptionExpirationTime: safeSubscription.subscription.expirationTime
		})
		.where(eq(accounts.id, locals.user.id));

	try {
		await sendNotification(locals.user, 'test notification', [new OpenAppAction(), new OpenProfileAction()]);
	} catch (e) {
		await locals.db
			.update(accounts)
			.set({
				subscriptionAuth: null,
				subscriptionP256Dh: null,
				subscriptionEndpoint: null,
				subscriptionExpirationTime: null
			})
			.where(eq(accounts.id, locals.user.id));
	}

	const [updated] = await locals.db
		.select()
		.from(accounts)
		.where(eq(accounts.id, locals.user.id))
		.limit(1);

	return new Response(JSON.stringify(serializeUser(updated)));
};

export const DELETE: RequestHandler = async ({ locals }) => {
	if (!locals.user) {
		redirect(303, '/login');
	}

	await locals.db
		.update(accounts)
		.set({
			subscriptionAuth: null,
			subscriptionP256Dh: null,
			subscriptionEndpoint: null,
			subscriptionExpirationTime: null
		})
		.where(eq(accounts.id, locals.user.id));

	const [updated] = await locals.db
		.select()
		.from(accounts)
		.where(eq(accounts.id, locals.user.id))
		.limit(1);

	return new Response(JSON.stringify(serializeUser(updated)));
};
