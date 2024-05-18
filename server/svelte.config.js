import adapter from '@sveltejs/adapter-node';
import { preprocess } from 'svelte/compiler';

/** @type {import('@sveltejs/kit').Config} */
const config = {
	preprocess: preprocess(),
	kit: {
		adapter: adapter({

		}),
		csrf: {
			checkOrigin: false,
		}
	},
};

export default config;
