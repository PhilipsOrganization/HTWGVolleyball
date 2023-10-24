<script lang="ts">
	import { enhance } from '$app/forms';
</script>

<div>
	<h1><span>register /</span> <a href="/login">login</a></h1>

	<form action="?/register" method="post" use:enhance>
		<field>
			<label for="username">username</label>
			<input type="text" name="username" id="username" autocomplete="username" />
		</field>
		<field>
			<label for="email">email</label>
			<input type="email" name="email" id="email" autocomplete="email" />
		</field>
		<field>
			<label for="password">password</label>
			<input type="password" name="password" id="password" autocomplete="new-password" />
		</field>

		<div id="actions">
			<button>register</button>
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

	span {
		view-transition-name: register-header;
	}
	
	a{
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

	#actions {
		display: flex;
		flex-direction: row;
		justify-content: flex-end;
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
		view-transition-name: action-button;
	}
</style>
