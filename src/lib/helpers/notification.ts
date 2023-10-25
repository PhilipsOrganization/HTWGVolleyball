import { env } from '$env/dynamic/private';
import type { User } from '$lib/db/entities';
import webpush from 'web-push';

const publicVapidKey = env.VITE_VAPID_PUBLIC;
const privateVapidKey = env.VAPID_PRIVATE;

if (!publicVapidKey || !privateVapidKey) {
	throw new Error('VAPID keys not set');
}

webpush.setVapidDetails('https://volleyballhtwg.netlify.app', publicVapidKey, privateVapidKey);

export async function sendNotification(user: User, payload: string) {
	const subscription = user.subscription;

	if (!subscription) {
		return;
	}

	await webpush.sendNotification(subscription.toJSON(), JSON.stringify({ title: payload }));
}
