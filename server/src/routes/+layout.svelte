<script>
	import { onNavigate } from '$app/navigation';
	import Header from '$lib/components/header.svelte';

	/**
	 * @param {() => Promise<void>} callback
	 */
	function startViewTransition(callback) {
		return new Promise((resolve) => {
			// @ts-ignore
			const transition = document.startViewTransition(() => {
				resolve(transition);
				return callback();
			});
		});
	}

	onNavigate(async (navigation) => {
		if ('startViewTransition' in document) {
			await startViewTransition(() => Promise.race([navigation.complete, new Promise((resolve) => setTimeout(resolve, 200))]));
		}
	});
</script>

<Header />
<slot />

<style>
	:global(body) {
		margin: 0;
		padding: 0;
		background: #131313;
		color: #e0e0e0;
		font-family: Nono;
		font-weight: 100;
		min-height: 100dvh;
		font-size: 16px;
		display: flex;
		flex-direction: column;
		text-underline-position: under;
		text-decoration-thickness: 0px;
	}

	/* variable font */
	@font-face {
		font-family: Nono;
		src: local(Nono), url('/fonts/NotoSansMono-VariableFont_wdth,wght.ttf') format('truetype');
		font-display: swap;
	}

	:root:view-transition-group(*) {
		animation-duration: 700ms;
	}

	:global(h1),
	:global(h2),
	:global(h3),
	:global(h4),
	:global(h5),
	:global(h6) {
		font-weight: 400;
	}

	:global(a) {
		text-decoration: none;
		color: unset;
		font-weight: 400;
	}

	:global(button) {
		all: unset;
		cursor: pointer;
		font-weight: 400;
	}
</style>
