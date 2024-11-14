<script>
	export let data;
</script>

<h1>{data.group.name}</h1>

<h2>Members</h2>
<ul>
	{#each data.members as member}
		<li>
			<a href="/admin/users/{member.id}/stats">{member.name}</a>
		</li>
	{:else}
		<p>No members</p>
	{/each}
</ul>
