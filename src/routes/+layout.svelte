<script>
	import { page } from '$app/stores';
	import { Role } from '$lib/db/role';
</script>

<header>
	<h1>Register for Volleyball</h1>
	{#if $page.data.user}
		<span>{$page.data.user.username}</span>
		<a class="accent margin" href="/logout">Logout</a>
		<a class="accent margin" href="/profile">Profile</a>
		{#if $page.data.user.role !== Role.USER}
			<a class="accent margin" href="/admin">Admin</a>
		{/if}
	{:else}
		<a class="accent" href="/login">Login</a>
	{/if}
	<img src="/Volleyball_icon.svg" alt="" />
</header>

<slot />

<style>
	:global(body) {
		--c0: #282828;
		--c20: #3b3b37;
		--c40: #4d4747;
		--c80: #d0d0d0;
		--c100: white;
		--cAccent: #55b5fa;
		--breakpoint-sm: 576px;
		--breakpoint-md: 768px;

		overflow-x: hidden;
		color: var(--c0);
	}

	header {
		background: var(--c20);
		position: relative;
		padding: 15px 30px;
		color: var(--c100);
	}

	h1 {
		font-size: 20px;
		font-weight: bold;
		margin: 0;
		text-shadow: 0px 0px 10px var(--c20);
	}

	img {
		height: 200%;
		position: absolute;
		top: -50%;
		right: -10px;
		bottom: -50%;
	}

	a.margin {
		margin-left: 10px;
	}

	a.accent {
		color: var(--cAccent);
	}
</style>
