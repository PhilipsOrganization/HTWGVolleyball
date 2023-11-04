import type { Handle } from '@sveltejs/kit';
import { MikroORM } from '@mikro-orm/core';
import type { SqlEntityManager } from '@mikro-orm/postgresql';
import { building } from '$app/environment';
import { setEnv as notificationEnv } from '@lib/notifications';
import { setEnv as databaseEnv, User, config } from '@lib/database';

let orm: MikroORM;

if (!building) {
	databaseEnv(process.env);
	notificationEnv(process.env);
	
	orm = await MikroORM.init(config);

	const migrator = orm.getMigrator();
	await migrator.createMigration();
	await migrator.up();
}

export const handle: Handle = async ({ event, resolve }) => {
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
};
