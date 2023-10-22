<div>
	<h1>Login / <a href="/register">Register</a></h1>

	<form action="?/login" method="post">
		<fieldset>
			<label for="username">Username</label>
			<input type="text" name="username" id="username" autocomplete="username"/>
		</fieldset>
		<fieldset>
			<label for="password">Password</label>
			<input type="password" name="password" id="password" autocomplete="current-password" />
		</fieldset>
		<button class="highlight">Login</button>
	</form>
</div>

<style>
	div {
		padding: 20px;
		margin: 20svh auto 0;
		width: 240px;
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
	}

	label {
		font-size: 18px;
		margin-left: 8px;
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
		margin-top: 10px;
		padding: 10px;
		border-radius: 8px;
		border: none;
		background-color: var(--cAccent);
		color: white;
		font-size: 16px;
	}
</style>
