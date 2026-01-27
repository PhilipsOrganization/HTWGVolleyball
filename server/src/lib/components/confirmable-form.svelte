<script>
	import Modal from './modal.svelte';
	import { assert, assertInstanceOf } from '$lib';

	/**
	 * @typedef {Object} Props
	 * @property {import('svelte').Snippet<[any, any]>} [children]
	 * @property {string} message
	 */

	/** @type {Props} */
	let { children, message } = $props();

	let openDialog = $state(false);

	/**
	 * Handles the click event on the button to open the confirmation dialog.
	 * @param {MouseEvent} event
	 */
	function handleClick(event) {
		event.preventDefault();
		openDialog = true;
		console.log('Opening confirm dialog');
	}

	/**
	 * Handles the click event on the submit button inside the confirmation dialog.
	 * @param {any} event
	 */
	function fireSubmit(event) {
		const target = event.target;
		assert(target);
		assertInstanceOf(target, HTMLElement);
		const form = target.closest('form');
		if (!form) {
			console.warn('No form found to submit');
			return;
		}

		form?.dispatchEvent(new Event('submit', { bubbles: true }));
		openDialog = false;
		console.log('Firing submit from confirm dialog');
	}
</script>

{#if children}
	{@render children(handleClick, 'button')}
{:else}
	<button type="button" onclick={handleClick}>Open Confirm Dialog</button>
{/if}

{#if openDialog}
	<Modal onClose={() => (openDialog = false)} cancelButton={false}>
		<h2 class="message-heading">{message}</h2>
		<!-- <p class="mt-2">This action cannot be undone.</p> -->

		<div class="button-container">
			<button autofocus type="button" class="cancel-button" onclick={() => (openDialog = false)}> Cancel </button>
			{#if children}
				{@render children?.(fireSubmit, 'submit')}
			{:else}
				<button type="submit" onclick={fireSubmit}>Confirm</button>
			{/if}
		</div>
	</Modal>
{/if}

<style>
	.message-heading {
		font-size: 1.25rem;
		font-weight: 500;
		color: #e0e0e0;
		margin: 0;
	}

	.button-container {
		margin-top: 1rem;
		display: flex;
		justify-content: space-between;
		gap: 1rem;
	}

	.cancel-button {
		padding: 0.75rem 1.5rem;
		border-radius: 0.5rem;
		background-color: #252525;
		color: #e0e0e0;
		border: none;
		cursor: pointer;
		font-weight: 400;
		transition: background-color 150ms ease-in-out;
	}

	.cancel-button:hover {
		background-color: #333;
	}

	.cancel-button:focus {
		outline: none;
		box-shadow: 0 0 0 2px #9cc1cf;
	}
</style>
