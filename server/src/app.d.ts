// See https://kit.svelte.dev/docs/types#app

import type { Account, DB } from '$lib/db/schema.ts';


// for information about these interfaces
declare global {
	namespace App {
		// interface Error {}
		interface Locals {
			db: DB;
			user?: Account;
		}
		// interface PageData {}
		// interface Platform {}
	}
}

export { };

