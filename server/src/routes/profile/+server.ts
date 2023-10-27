import { Subscription } from '$lib/db';
import { sendNotification } from '@lib/notifications';
import { redirect } from '@sveltejs/kit';
import { z } from 'zod';
import type { RequestHandler } from './$types';

export const POST: RequestHandler = async ({ request, locals }) => {
	if (!locals.user) {
		throw redirect(303, '/login');
	}

	const body = (await request.json()) as unknown;
	const safeSubscription = z
		.object({
			subscription: z.object({
				endpoint: z.string(),
				expirationTime: z.union([z.string(), z.undefined()]),
				keys: z.object({
					p256dh: z.string(),
					auth: z.string()
				})
			})
		})
		.parse(body);

	const subscription = new Subscription(safeSubscription);
	locals.user.subscription = subscription;

	try {
		await sendNotification(locals.user, 'test notification');
	} catch (e) {
		locals.user.subscription = undefined;
	}

	await locals.em.persistAndFlush(locals.user);

	return new Response(JSON.stringify(locals.user.toJSON()));
};

export const DELETE: RequestHandler = async ({ locals }) => {
	if (!locals.user) {
		throw redirect(303, '/login');
	}

	locals.user.subscription = undefined;
	await locals.em.persistAndFlush(locals.user);

	return new Response(JSON.stringify(locals.user.toJSON()));
};