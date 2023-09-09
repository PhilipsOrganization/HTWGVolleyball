// See https://kit.svelte.dev/docs/types#app

import type { SqlEntityManager } from "@mikro-orm/sqlite";


// for information about these interfaces
declare global {
	namespace App {
		// interface Error {}
		interface Locals {
			em: SqlEntityManager;
		}
		// interface PageData {}
		// interface Platform {}
	}
}

export { };
