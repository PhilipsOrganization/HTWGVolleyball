import { sequence } from '@sveltejs/kit/hooks';
import * as Sentry from '@sentry/sveltekit';
import type { Handle } from '@sveltejs/kit';
import { config } from './lib/db/micro-orm.config';
import { MikroORM } from '@mikro-orm/core';
import type { SqlEntityManager } from '@mikro-orm/postgresql';
import { User } from '$lib/db/entities';
import { building } from '$app/environment';

Sentry.init({
	dsn: "https://be81ce9ae21bfe95942756c397f31dfe@o4505130185261056.ingest.sentry.io/4506236862988288",
	tracesSampleRate: 1
})

let orm: MikroORM;
// let isMigrating: Promise<void> | undefined = undefined;

if (!building) {
	orm = await MikroORM.init(config);

	// if (!isMigrating) {
	// 	isMigrating = new Promise((resolve) => {
	// 		const migrator = orm.getMigrator();

	// 		migrator.createMigration()
	// 			.then(() => migrator.up())
	// 			.then(() => {
	// 				resolve();
	// 				isMigrating = undefined;
	// 			});
	// 	});
	// }
}

export const handle: Handle = sequence(Sentry.sentryHandle(), async ({ event, resolve }) => {
	// if (isMigrating) {
	// 	await isMigrating;
	// }

	if (building) {
		return await resolve(event);
	}

	event.locals.em = orm.em.fork() as SqlEntityManager;
	const session = event.cookies.get('user');

	if (session) {
		const user = await event.locals.em.findOne(
			User,
			{ sessionToken: session },
			{ populate: ['courses'] }
		);
		if (user) {
			event.locals.user = user;
		}
	}

	return await resolve(event);
});

export const handleError = Sentry.handleErrorWithSentry();