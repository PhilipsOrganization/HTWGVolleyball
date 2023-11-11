<script lang="ts">
	import { enhance } from '$app/forms';

	export let form;
</script>

<div>
	<h1><span>reset password /</span> <a href="/login">back</a></h1>

	<form action="?/reset-pw" method="post" use:enhance>
		<field>
			<label for="username">username or email</label>
			<input type="text" name="username" id="username" autocomplete="username" />
		</field>
        {#if form}
            <p class="error">{form.error}</p>
        {/if}

		<button id="login-btn">send reset email</button>
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

	span {
		view-transition-name: login-header;
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

	a {
		font-size: 18px;
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

	button#login-btn {
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

	button#login-btn:hover {
		background: #d9f1a9;
	}

	.error {
		color: #eb714f;
		margin: 5px 1rem;
	}
</style>
