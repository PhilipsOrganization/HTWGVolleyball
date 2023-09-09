<!-- login page -->

<div>
	<h1>Login</h1>
	<a href="/register">Register</a>

	<form action="?/login" method="post">
		<label for="username">Username</label>
		<input type="text" name="username" id="username" />
		<label for="password">Password</label>
		<input type="password" name="password" id="password" />
		<button>Login</button>
	</form>
</div>

<style>
	form {
		display: flex;
		flex-direction: column;
	}

	div {
		display: flex;
		flex-direction: column;
		align-items: center;
	}
</style>
