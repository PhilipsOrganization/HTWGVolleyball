<script lang="ts">
	import { enhance } from '$app/forms';
</script>

<div>
	<h1>register / <a href="/login">login</a></h1>

	<form action="?/register" method="post" use:enhance>
		<fieldset>
			<label for="username">username</label>
			<input type="text" name="username" id="username" autocomplete="username" />
		</fieldset>
		<fieldset>
			<label for="email">email</label>
			<input type="email" name="email" id="email" autocomplete="email" />
		</fieldset>
		<fieldset>
			<label for="password">password</label>
			<input type="password" name="password" id="password" autocomplete="new-password" />
		</fieldset>

		<div>
			<a href="/">back</a>
			<button class="highlight">register</button>
		</div>
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

	form fieldset {
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
		text-decoration: underline;
	}
</style>
