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
		color: #fff;
		font-family: monospace;
		min-height: 100dvh;
		font-size: 16px;
		display: flex;
		flex-direction: column;
		text-underline-position: under;
		text-decoration-thickness: 0px;
	}

	:root:view-transition-group(*) {
		animation-duration: 700ms;
	}

	:global(a) {
		text-decoration: none;
		color: unset;
	}

	:global(button) {
		all: unset;
		cursor: pointer;
	}
</style>
