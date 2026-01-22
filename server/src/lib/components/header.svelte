<script>
	import { Role } from '$lib/db/role';
	import { page } from '$app/stores';

	let isAdmin = $derived($page.route.id?.includes('/admin') || $page.url.searchParams.has('admin'));
</script>

<header class:compact={isAdmin}>
	<nav>
		{#if $page.data.globalUser}
			<a href="/profile">Profile</a>
			{#if $page.data.globalUser.role !== Role.USER}
				<a href="/admin">Admin</a>
			{/if}
			<a href="/logout">Logout</a>
		{:else}
			<a class="accent" href="/login">Login</a>
		{/if}
	</nav>
	<a href="/courses">
		<h1>
			Volleyball HTWG
			{#if isAdmin}
				<span class="admin-badge">Admin</span>
			{/if}
		</h1>
	</a>

	{#if !isAdmin}
		<img src="/Volleyball_icon.svg" alt="Volleyball" />
	{/if}
</header>

<style>
	header {
		position: relative;
		display: flex;
		flex-direction: column;
		justify-content: space-between;
		padding: 0 1rem;
		background-color: #9cc1cf;
		height: min(30dvh, 300px);
		border-bottom-left-radius: 16px;
		border-bottom-right-radius: 16px;
		overflow: hidden;
		box-sizing: border-box;
	}

	header.compact {
		height: min(20dvh, 180px);
		border-bottom-left-radius: 12px;
		border-bottom-right-radius: 12px;
	}

	h1 {
		display: flex;
		align-items: center;
		gap: 0.75rem;
		position: relative;
		max-width: 80%;
		z-index: 1;
		padding: 0;
		font-size: 3rem;
		font-weight: 100;
		color: #000;
	}

	header.compact h1 {
		font-size: 2rem;
	}

	.admin-badge {
		font-size: 0.75rem;
		padding: 0.25rem 0.6rem;
		background: rgba(0, 0, 0, 0.15);
		border-radius: 4px;
		text-transform: uppercase;
		letter-spacing: 1px;
		font-weight: 400;
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
