<script>
	import { Role } from '$lib/db/role';

	export let data;
</script>

<h1>Users</h1>
<section>
	{#each data.users as user}
		<div>
			<p>{user.username}</p>
			<b>{user.role}</b>
		</div>
	{/each}
</section>

<style>
	section {
		display: flex;
		flex-direction: column;
		gap: 1rem;
		max-width: min(1000px, 90%);
		margin: 0 auto;
	}

	div {
		display: flex;
		justify-content: space-between;
		align-items: center;
	}
</style>
