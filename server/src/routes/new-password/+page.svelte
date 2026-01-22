<script lang="ts">
	import { enhance } from '$app/forms';
	import { page } from '$app/stores';

	let { form } = $props();

	let token = $derived($page.url.searchParams.get('token'));
	let userId = $derived($page.url.searchParams.get('user'));
</script>

<div>
	<h1>reset password</h1>

	<form method="post" use:enhance>
		<input type="hidden" name="token" value={token} />
		<input type="hidden" name="user" value={userId} />

		<field>
			<label for="password">password</label>
			<input type="password" name="password" id="password" autocomplete="new-password" />
		</field>

		<field>
			<label for="password2">confirm password</label>
			<input type="password" name="password2" id="password2" autocomplete="new-password" />
		</field>

		<button type="submit">Reset</button>
		{#if form && form.error}
			<p class="error">{form.error}</p>
		{/if}
	</form>
</div>

<style>
	div {
		margin: 2rem auto 0;
	}

	h1 {
		border-bottom: 2px solid var(--cAccent);
		margin: -10px -20px 20px -20px;
		width: 100%;
		text-align: center;
		padding-bottom: 10px;
	}

	input {
		border: 1px solid var(--cAccent);
		padding: 1em;
		border-radius: 8px;
		border: 1px solid #9cc1cf;
		background: black;
		color: #e0e0e0;
	}

	label {
		color: rgb(182, 182, 182);
	}

	form {
		display: flex;
		flex-direction: column;
		gap: 20px;
	}

	form field {
		display: flex;
		flex-direction: column;
		border: none;
		padding: 2px;
	}

	div {
		display: flex;
		flex-direction: column;
		align-items: center;
	}

	button {
		display: flex;
		flex-direction: row;
		justify-content: flex-end;
		width: 80vw;
		background: #ecfbc7;
		color: black;
		border: none;
		padding: 1.5rem 3rem;
		margin-top: 2rem;
		box-sizing: border-box;
		color: black;
		border: none;
		font-size: 20px;

		view-transition-name: action-button;
	}

	.error {
		color: #eb714f;
		font-weight: bold;
		margin: 5px 1rem;
		text-align: center;
	}
</style>
