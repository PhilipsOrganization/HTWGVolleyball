<script>
	import { onNavigate } from '$app/navigation';
	import Header from '$lib/components/header.svelte';
	import InfoModal from '$lib/components/info-modal.svelte';
	import Toast from '$lib/components/toast.svelte';
	import { toasts } from '$lib/helpers/toast';

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
<div id="toasts">
	{#each $toasts as toast (toast.id)}
		<Toast {...toast} />
	{/each}
</div>

<InfoModal />
<slot />

<style>
	:global(body) {
		margin: 0;
		padding: 0;
		padding-bottom: 6rem;
		background: #131313;
		color: #e0e0e0;
		font-family: 'Roboto Mono', monospace;
		font-weight: 100;
		min-height: 100svh;
		font-size: 16px;
		display: flex;
		flex-direction: column;
		text-underline-position: under;
		text-decoration-thickness: 0px;
	}

	#toasts {
		position: fixed;
		display: flex;
		flex-direction: column;
		align-items: flex-end;
		gap: 1rem;
		padding: 1rem;
		z-index: 1000;
		bottom: 0;
		right: 0;
		width: min(80%, 450px);
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
