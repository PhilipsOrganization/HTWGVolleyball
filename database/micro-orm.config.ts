import { entities } from '@lib/database';
import type { Options } from '@mikro-orm/postgresql';

const env = process.env;

export const config: Options = {
	type: 'postgresql',
	entities,
	discovery: {
		disableDynamicFileAccess: true,
		requireEntitiesArray: true
	},
	host: env.MIKRO_ORM_HOST ?? 'localhost',
	port: parseInt(env.MIKRO_ORM_PORT ?? '5432'),
	user: env.MIKRO_ORM_USER ?? 'postgres',
	password: env.MIKRO_ORM_PASSWORD ?? 'postgres',
	dbName: env.MIKRO_ORM_DB_NAME ?? 'volleyball',
	cache: {
		enabled: false
	},
	debug: true,
	forceUtcTimezone: true,
	validate: true,
	strict: true,
	migrations: {
		path: './src/lib/db/migrations',
		emit: 'js'
	}
};
