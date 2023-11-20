<script>
	/** * @type {string}  */
	export let message;

	/** @type {HTMLDialogElement} */
	let dialogEl;
</script>

<dialog bind:this={dialogEl}>
	<h1>Confirmation</h1>
	<p>{message}</p>
	<div>
		<form class="abort" method="dialog">
			<button>Abort</button>
		</form>
		<slot name="confirm" />
	</div>
</dialog>

<form on:submit={() => dialogEl.showModal()}>
	<slot name="button" />
</form>

<style>
	dialog {
		background: #3c3c3c;
		color: white;
		padding: 3rem;
		border-radius: 20px;
		border: 4px solid #9cc1cf;
		box-shadow: 0 0 10px 0 rgba(0, 0, 0);
	}

	dialog::backdrop {
		background: rgba(0, 0, 0, 0.5);
	}

	h1 {
		margin-top: 0;
	}

	div {
		display: flex;
		flex-direction: row;
		flex-wrap: wrap;
		justify-content: space-between;
		gap: 1rem;
	}

	form.abort {
		flex: 1 1 20%;
		background: #ecfbc7;
		color: black;
		border: none;
	}

	form.abort button {
		width: 100%;
		height: 100%;
		align-items: center;
		justify-content: center;
		text-align: center;
	}
</style>
