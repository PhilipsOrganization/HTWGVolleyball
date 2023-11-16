import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig } from 'vite';
import viteTs from 'vite-plugin-ts';

export default defineConfig({
	plugins: [viteTs(), sveltekit()],
	esbuild: {
		minifyIdentifiers: false,
		keepNames: true,
	},
});