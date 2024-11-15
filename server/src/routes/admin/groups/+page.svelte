<script>
	export let data;
</script>

<h1>Groups</h1>

<ul>
	{#each data.groups as group}
		<li>
			<a href="/admin/groups/{group.id}">
				<h2>{group.name}</h2>
			</a>
		</li>
	{/each}
</ul>

<form action="?/create" method="POST">
	<h2>Create a new group:</h2>
	<input type="text" name="name" placeholder="Name" required />
	<button type="submit">Create</button>
</form>

<style>
	form {
		display: flex;
		border: 1px solid gray;
		padding: 1rem;
		gap: 1rem;
		max-width: max-content;
		flex-flow: row wrap;
		margin: 4rem 2rem;
	}

	h2 {
		flex: 1 1 100%;
	}

	input {
		flex: 2 1 50%;
		padding: 0.8rem;
	}

	button {
		background: #9cc1cf;
		color: #000;
		border: none;
		padding: 0.5rem 1rem;
		cursor: pointer;
		flex: 1 1;
		text-align: center;
	}
</style>
