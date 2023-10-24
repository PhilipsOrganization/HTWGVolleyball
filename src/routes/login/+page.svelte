<div>
	<h1>login / <a href="/register">register</a></h1>

	<form action="?/login" method="post">
		<fieldset>
			<label for="username">username</label>
			<input type="text" name="username" id="username" autocomplete="username" />
		</fieldset>
		<fieldset>
			<label for="password">password</label>
			<input type="password" name="password" id="password" autocomplete="current-password" />
		</fieldset>

		<div id="actions">
			<a href="/">back</a>
			<button class="highlight">login</button>
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
		color: white;
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

	#actions {
		display: flex;
		flex-direction: row;
		justify-content: space-between;
		width: 80vw;
		background: #ecfbc7;
		color: black;
		border: none;
		padding: 1.5rem 3rem;
		margin-top: 2rem;
		font-weight: 100;
		box-sizing: border-box;
	}

	button {
		color: black;
		border: none;
		font-size: 20px;
		padding: 0;
	}
</style>
