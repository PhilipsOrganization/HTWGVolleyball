<script>
	import { toasts } from '$lib/helpers/toast';
	import { fly } from 'svelte/transition';

	/**
	 * @type {string}
	 */
	export let message;

	/**
	 * @type {"error" | "success" | "info"}
	 * */
	export let type;

	/**
	 * @type {number}
	 */
	export let id;

	function dismiss() {
		$toasts = $toasts.filter((toast) => toast.id !== id);
	}
</script>

<button
	class="toast"
	class:error={type === 'error'}
	class:success={type === 'success'}
	in:fly={{ x: 500 }}
	out:fly={{ x: 500 }}
    on:click={dismiss}
>
	<p>
		{message}
	</p>
</button>

<style>
	button {
		padding: 0 1rem;
		background-color: #cecece;
		color: black;
		font-weight: 500;
		border-radius: 0.5rem;
		box-shadow: 0 0 1rem rgba(0, 0, 0, 0.2);
		z-index: 1000;
		transition: opacity 0.3s ease;
	}

	.error {
		background-color: #eb714f;
	}

	.success {
		background-color: hsla(77, 50%, 60%);
	}
</style>
