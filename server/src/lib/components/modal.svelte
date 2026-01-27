<script>
	import { assert } from '$lib';
	import { fade } from 'svelte/transition';

	let dialog = $state();

	let { children, onClose, cancelButton = true } = $props();

	$effect(() => {
		assert(dialog);
		dialog.showModal();
	});

	/**
	 * Handles the click event outside the dialog to close it.
	 * @param {MouseEvent} event
	 */
	function handleOutsideClick(event) {
		if (event.target === dialog) {
			handleClose();
		}
	}

	function handleClose() {
		onClose();
	}

	/**
	 * Traps focus within the dialog when tabbing.
	 * @param {KeyboardEvent} event
	 */
	function trapFocus(event) {
		assert(dialog);
		const focusableElements = dialog.querySelectorAll(
			'a[href], area[href], input:not([disabled]), select:not([disabled]), textarea:not([disabled]), button:not([disabled]), [tabindex]:not([tabindex="-1"])'
		);
		const firstElement = focusableElements[0];
		const lastElement = focusableElements[focusableElements.length - 1];

		if (event.target === lastElement && event.key === 'Tab' && !event.shiftKey) {
			event.preventDefault();
			firstElement.focus();
		} else if (event.target === firstElement && event.key === 'Tab' && event.shiftKey) {
			event.preventDefault();
			lastElement.focus();
		}
	}
</script>

<dialog in:fade={{ duration: 200 }} bind:this={dialog} onclick={handleOutsideClick} onkeydown={trapFocus}>
	{#if cancelButton}
		<button autofocus class="modal-close-btn" onclick={handleClose}>
			<span class="sr-only">Close</span>
			<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
				<path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
			</svg>
		</button>
	{/if}

	{@render children()}
</dialog>

<style>
	/* Modal dialog styles */
	dialog {
		position: fixed;
		margin: auto;
		max-height: 80vh;
		overflow: hidden;
		overflow-y: auto;
		border-radius: 1rem;
		border: 1px solid #2a2a2a;
		background-color: #1f1f1f;
		padding: 1.5rem;
		color: #e0e0e0;
		box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.3);
		transition: all 150ms ease-in-out;
		width: 100%;
		max-width: 28rem;
		backdrop-filter: blur(10px);
		-webkit-backdrop-filter: blur(10px);
	}

	@media (min-width: 768px) {
		dialog {
			max-width: 42rem;
		}
	}

	@media (min-width: 1024px) {
		dialog {
			max-width: 48rem;
		}
	}

	/* Close button styles */
	.modal-close-btn {
		position: absolute;
		right: 0.75rem;
		top: 0.75rem;
		z-index: 10;
		border-radius: 9999px;
		padding: 0.5rem;
		color: #aaa;
		background: transparent;
		border: none;
		cursor: pointer;
		transition: color 150ms ease-in-out;
		font-weight: 400;
	}

	.modal-close-btn:hover {
		color: #e0e0e0;
	}

	.modal-close-btn:focus {
		outline: none;
		box-shadow: 0 0 0 2px #9cc1cf;
	}

	.modal-close-btn svg {
		width: 1.5rem;
		height: 1.5rem;
	}
</style>
