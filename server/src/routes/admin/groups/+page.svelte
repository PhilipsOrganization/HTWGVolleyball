<script>
	import { enhance } from '$app/forms';

	let { data } = $props();
</script>

<section>
	<div class="page-header">
		<h1>Groups</h1>
		<span class="count">{data.groups.length} total</span>
	</div>

	<div class="create-form">
		<form action="?/create" method="POST" use:enhance>
			<input type="text" name="name" placeholder="New group name..." required />
			<button type="submit">Create Group</button>
		</form>
	</div>

	{#if data.groups.length > 0}
		<div class="groups-grid">
			{#each data.groups as group}
				<a href="/admin/groups/{group.id}" class="group-card">
					<div class="group-info">
						<span class="group-icon">◈</span>
						<span class="group-name">{group.name}</span>
					</div>
					<span class="arrow">→</span>
				</a>
			{/each}
		</div>
	{:else}
		<div class="empty-state">
			<p>No groups yet</p>
			<span>Create your first group above</span>
		</div>
	{/if}
</section>

<style>
	section {
		display: flex;
		flex-direction: column;
		gap: 1.5rem;
		width: 100%;
		max-width: 700px;
	}

	.page-header {
		display: flex;
		align-items: baseline;
		gap: 1rem;
	}

	.page-header h1 {
		margin: 0;
		font-size: 1.5rem;
		font-weight: 300;
	}

	.page-header .count {
		font-size: 0.875rem;
		color: #666;
	}

	.create-form {
		background: #1a1a1a;
		border: 1px solid #2a2a2a;
		border-radius: 10px;
		padding: 1.25rem;
	}

	.create-form form {
		display: flex;
		gap: 1rem;
		flex-wrap: wrap;
	}

	.create-form input {
		flex: 1;
		min-width: 200px;
		padding: 0.75rem 1rem;
		background: #1f1f1f;
		border: 1px solid #2a2a2a;
		border-radius: 8px;
		color: #e0e0e0;
		font-size: 0.9rem;
		font-family: inherit;
	}

	.create-form input:focus {
		outline: none;
		border-color: #9cc1cf;
	}

	.create-form input::placeholder {
		color: #555;
	}

	.create-form button {
		padding: 0.75rem 1.5rem;
		background: #9cc1cf;
		color: #000;
		border-radius: 8px;
		font-size: 0.9rem;
		font-weight: 500;
		transition: all 0.15s ease;
	}

	.create-form button:hover {
		background: #b0d1dc;
	}

	.groups-grid {
		display: flex;
		flex-direction: column;
		gap: 0.5rem;
	}

	.group-card {
		display: flex;
		justify-content: space-between;
		align-items: center;
		padding: 1rem 1.25rem;
		background: #1a1a1a;
		border: 1px solid #2a2a2a;
		border-radius: 10px;
		transition: all 0.15s ease;
	}

	.group-card:hover {
		background: #1f1f1f;
		border-color: #3a3a3a;
	}

	.group-info {
		display: flex;
		align-items: center;
		gap: 0.75rem;
	}

	.group-icon {
		color: #9cc1cf;
		font-size: 1.1rem;
	}

	.group-name {
		font-size: 0.95rem;
	}

	.arrow {
		color: #555;
		font-size: 1.1rem;
		transition: transform 0.15s ease;
	}

	.group-card:hover .arrow {
		transform: translateX(3px);
		color: #9cc1cf;
	}

	.empty-state {
		text-align: center;
		padding: 3rem 2rem;
		background: #1a1a1a;
		border: 1px dashed #2a2a2a;
		border-radius: 12px;
	}

	.empty-state p {
		margin: 0 0 0.5rem;
		font-size: 1.1rem;
		color: #888;
	}

	.empty-state span {
		font-size: 0.875rem;
		color: #555;
	}
</style>
