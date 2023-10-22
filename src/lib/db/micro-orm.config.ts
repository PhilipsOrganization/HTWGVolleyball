import { entities } from '$lib/db/entities';
import type { Options } from '@mikro-orm/core';

export const config: Options = {
	type: 'sqlite',
	dbName: 'prod.db',
	entities,
	debug: true,
	forceUtcTimezone: true,
	validate: true,
	strict: true,
	migrations: {
		emit: 'js'
	}
};
