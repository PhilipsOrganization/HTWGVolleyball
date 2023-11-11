<script lang="ts">
	import { enhance } from '$app/forms';

	export let form;
</script>

<section>
	<h1><span class="main">login /</span> <a class="secondary" href="/register">register</a></h1>

	<form action="?/login" method="post" use:enhance>
		<field>
			<label for="username"
				>username
				{#if form?.missingCredentials}
					<small class="error">required</small>
				{/if}

				{#if form?.userNotFound}
					<small class="error">user not found</small>
				{/if}
			</label>
			<input type="text" name="username" id="username" autocomplete="username" />
		</field>
		<field>
			<label for="password"
				>password

				{#if form?.missingCredentials}
					<small class="error">required</small>
				{/if}
				{#if form?.wrongPassword}
					<small class="error">wrong password</small>
				{/if}
			</label>
			<input type="password" name="password" id="password" autocomplete="current-password" />
		</field>

		<button id="login-btn">login</button>
	</form>

	<div id="line" />

	<div id="more">
		<form action="?/authenticate" method="post">
			<button>login with Google</button>
		</form>

		<a href="/reset-pw">reset password</a>
	</div>
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

	#line {
		width: 80vw;
		height: 1px;
		background: #9cc1cf;
		margin: 1.5rem 0;
	}
	#more {
		display: flex;
		flex-direction: row;
		width: 100%;
		box-sizing: border-box;
		padding: 0 10vw 10rem;
		gap: 1rem;
		justify-content: space-between;
	}

	#more a {
		font-size: 16px;
	}

	/* break flex into colums at 545px width */
	@media (max-width: 545px) {
		#more {
			flex-direction: column;
			align-items: center;
		}
	}
</style>
