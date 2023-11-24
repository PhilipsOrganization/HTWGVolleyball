import { env } from '$env/dynamic/private';
import type { User } from '$lib/db/entities';
import webpush from 'web-push';
import { building } from '$app/environment';

const publicVapidKey = env.VITE_VAPID_PUBLIC;
const privateVapidKey = env.VAPID_PRIVATE;

// if (!building) {
// 	if (!publicVapidKey || !privateVapidKey) {
// 		throw new Error('VAPID keys not set');
// 	}

// 	webpush.setVapidDetails('https://volleyballhtwg.netlify.app', publicVapidKey, privateVapidKey);
// }


interface NotificationAction {
	action: string;
	title: string;
}

export class BasicAction implements NotificationAction {
	public openUrl?: string;
	constructor(public action: string, public title: string) { }
}

export class OpenCourseAction extends BasicAction {
	constructor(courseId: number) {
		super('open-course', 'Open Course');

		this.openUrl = `/courses/${courseId}`;
	}
}

export class OpenAppAction extends BasicAction {
	constructor() {
		super('open-app', 'Open');
		this.openUrl = '/';
	}
}

export class OpenProfileAction extends BasicAction {
	constructor() {
		super('open-profile', 'Profile');
		this.openUrl = '/profile';
	}
}

export class DropCourseAction extends BasicAction {
	constructor(courseId: number) {
		super('drop-course', 'Drop Course');

		this.openUrl = `/courses/${courseId}`;
	}
}

export async function sendNotification(user: User, payload: string, actions: NotificationAction[] = []) {
	const subscription = user.subscription;

	if (!subscription) {
		return;
	}

	await webpush.sendNotification(subscription.toJSON(), JSON.stringify({ title: payload, actions }));
}
