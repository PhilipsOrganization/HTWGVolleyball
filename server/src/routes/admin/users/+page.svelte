<script>
	export let data;
</script>

<section>
	<h1>Users</h1>
	<div id="users">
		{#each data.users as user}
			<p>
				<span>{user.username}</span>
				<span>{user.role}</span>
				<a href="/admin/users/{user.id}/stats">info</a>
			</p>
		{/each}
	</div>
</section>

<style>
	section {
		display: flex;
		flex-direction: column;
		gap: 1rem;
		max-width: min(1000px, 90%);
		margin: 0 auto;
		align-items: center;
	}

	p {
		display: flex;
		justify-content: space-between;
		align-items: center;
		width: 80vw;
		border-bottom: 1px solid #7d7d7d;
		padding: 0.5rem 0;
	}

	a {
		text-decoration: underline;
	}
</style>
