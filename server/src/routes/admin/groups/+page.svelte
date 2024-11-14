<script>
	export let data;
</script>

<h1>Groups</h1>

<form action="?/create" method="POST">
	<input type="text" name="name" placeholder="Name" required />
	<button type="submit">Create</button>
</form>

<ul>
	{#each data.groups as group}
		<li>
			<a href="/admin/groups/{group.id}">
				<h2>{group.name}</h2>
			</a>
		</li>
	{/each}
</ul>
