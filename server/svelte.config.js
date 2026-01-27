import adapter from 'svelte-adapter-bun';

/** @type {import('@sveltejs/kit').Config} */
const config = {
	runes: true,
	kit: {
		adapter: adapter(),
	}
};

export default config;
