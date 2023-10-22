// See https://kit.svelte.dev/docs/types#app

import type { User } from '$lib/db/entities/user';
import type { SqlEntityManager } from '@mikro-orm/sqlite';

// for information about these interfaces
declare global {
	namespace App {
		// interface Error {}
		interface Locals {
			em: SqlEntityManager;
			user?: User;
		}
		// interface PageData {}
		// interface Platform {}
	}
}

export {};
