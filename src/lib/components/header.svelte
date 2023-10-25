<script>
	import { Role } from '$lib/db/role';
	import { page } from '$app/stores';
</script>

<header>
	<nav>
		{#if $page.data.user}
			<a href="/profile">Profile</a>
			{#if $page.data.user.role !== Role.USER}
				<a href="/admin">Admin</a>
				<a href="/admin/users">Users</a>
			{/if}
			<a href="/logout">Logout</a>
		{:else}
			<a class="accent" href="/login">Login</a>
		{/if}
	</nav>
	<a href="/courses">
		<h1>
			Volleyball HTWG

			{#if $page.route.id?.includes('/admin') || $page.url.searchParams.has('admin')}
				- Admin
			{/if}
		</h1>
	</a>

	<img src="/Volleyball_icon.svg" alt="Volleyball" />
</header>

<style>
	header {
		position: relative;
		display: flex;
		flex-direction: column;
		justify-content: space-between;
		padding: 0 1rem;
		background-color: #9cc1cf;
		height: min(30vh, 300px);
		border-bottom-left-radius: 16px;
		border-bottom-right-radius: 16px;
		overflow: hidden;
		box-sizing: border-box;
	}

	h1 {
		display: block;
		position: relative;
		max-width: 60%;
		z-index: 1;
		padding: 0;
		font-size: 3rem;
		font-weight: 100;
		color: #000;
	}

	nav {
		display: flex;
		flex-direction: row;
		justify-content: space-between;
		width: 90vw;
		margin: 0.5rem auto;
		color: #000;
		z-index: 1;
		font-weight: 400;
	}

	img {
		position: absolute;
		inset: auto -10% 20px auto;
		width: 60vw;
	}
</style>
