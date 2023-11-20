<script lang="ts">
	import { enhance } from '$app/forms';

	export let form;
</script>

<section>
	<h1><span class="main">register /</span> <a class="secondary" href="/login">login</a></h1>

	<form action="?/register" method="post" use:enhance>
		<field>
			<label for="username"
				>full name

				{#if form?.missingCredentials}
					<small class="error">required</small>
				{/if}

				{#if form?.invalidUsername}
					<small class="error">invalid username, use your full name</small>
				{/if}

				{#if form?.userAlreadyExists}
					<small class="error">user already exists</small>
				{/if}
			</label>
			<input type="text" name="username" id="username" autocomplete="nickname" />
		</field>
		<field>
			<label for="email"
				>email

				{#if form?.missingCredentials}
					<small class="error">required</small>
				{/if}

				{#if form?.userAlreadyExists}
					<small class="error">user already exists</small>
				{/if}

				{#if form?.invalidEmail}
					<small class="error">invalid email</small>
				{/if}
			</label>
			<input type="email" name="email" id="email" autocomplete="email" />
		</field>
		<field>
			<label for="password"
				>password

				{#if form?.missingCredentials}
					<small class="error">required</small>
				{/if}

				{#if form?.weakPassword}
					<small class="error">weak password</small>
				{/if}
			</label>
			<input type="password" name="password" id="password" autocomplete="new-password" />
		</field>

		<button>register</button>
	</form>
</section>

<style>
	.main {
		view-transition-name: login-header;
	}

	.secondary {
		view-transition-name: register-header;
		font-size: 1.4rem;
	}

	section {
		margin: 2rem auto 0;
		display: flex;
		flex-direction: column;
		align-items: center;
	}

	h1 {
		border-bottom: 2px solid var(--cAccent);
		margin: -10px -20px 20px -20px;
		width: 100%;
		text-align: center;
		padding-bottom: 10px;
		font-size: 2rem;
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
		font-weight: 300;
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
		margin: 5px 1rem;
	}
</style>
