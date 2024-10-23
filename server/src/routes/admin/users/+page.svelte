<script>
	let { data } = $props();
</script>

<section>
	<h1>Users ({data.users.length})</h1>
	<div id="users">
		{#each data.users as user}
			<p>
				<span class="ellipsis">{user.username}</span>
				<span class="center">{user.role}</span>
				<a class="center" href="/admin/users/{user.id}/stats">info</a>
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
		width: 100%;
	}

	p {
		display: grid;
		grid-template-columns: 1fr 1fr 1fr;
		justify-content: space-between;
		align-items: center;
		width: 80vw;
		border-bottom: 1px solid #7d7d7d;
		padding: 0.5rem 0;
	}

	a {
		text-decoration: underline;
	}

	.center {
		text-align: center;
	}
	.ellipsis {
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;
	}
</style>
