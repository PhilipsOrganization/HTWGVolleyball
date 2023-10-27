import { entities } from './entities';
import type { Options } from '@mikro-orm/postgresql';

let env = process.env;

export function setEnv(e: any) {
	env = e;
}

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
