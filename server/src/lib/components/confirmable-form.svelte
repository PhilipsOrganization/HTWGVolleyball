<script>
	import { self } from 'svelte/legacy';

	
	/**
	 * @typedef {Object} Props
	 * @property {string} message
	 * @property {import('svelte').Snippet} [confirm]
	 * @property {import('svelte').Snippet} [button]
	 */

	/** @type {Props} */
	let { message, confirm, button } = $props();

	/** @type {HTMLDialogElement} */
	let dialogEl = $state();
</script>

<!-- svelte-ignore a11y_click_events_have_key_events -->
<!-- svelte-ignore a11y_no_noninteractive_element_interactions -->
<dialog bind:this={dialogEl} onclick={self(() => dialogEl.close())}>
	<h1>Confirmation</h1>
	<p>{message}</p>
	<div id="actions">
		<form class="abort" method="dialog">
			<button>Abort</button>
		</form>
		<div class="form-slot">
			{@render confirm?.()}
		</div>
	</div>
</dialog>

<form onsubmit={() => dialogEl.showModal()}>
	{@render button?.()}
</form>

<style>
	dialog {
		background: #3c3c3c;
		color: #fff;
		padding: 2rem min(5rem, 5%) 2rem;
		border-radius: 20px;
		border: 4px solid #9cc1cf;
		box-shadow: 0 0 10px #000;
		max-width: 98%;
		box-sizing: border-box;
	}

	@keyframes fade-in {
		0% {
			opacity: 0;
		}
		100% {
			opacity: 1;
		}
	}

	dialog::backdrop {
		background: rgba(0, 0, 0, 0.5);
	}

	p {
		font-weight: 200;
		margin: 3rem 0;
	}

	h1 {
		margin-top: 0;
		font-size: 2rem;
		font-weight: 100;
		text-align: center;
		margin-bottom: 2.5rem;
	}

	div#actions {
		display: flex;
		flex-direction: row;
		flex-wrap: wrap;
		justify-content: space-between;
		gap: 1rem;
	}

	form.abort,
	div.form-slot {
		flex: 1 1 47%;
		background: #ecfbc7;
		color: black;
		border: none;
		min-height: 3rem;
		display: flex;
		align-items: center;
		justify-content: center;
	}

	form.abort {
		background: transparent;
		color: #ecfbc7;
		flex: 1;
	}

	form.abort button {
		width: 100%;
		height: 100%;
		align-items: center;
		justify-content: center;
		text-align: center;
	}
</style>
