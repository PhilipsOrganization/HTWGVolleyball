<script lang="ts">
	let { data } = $props();
</script>

<section>
	<div class="page-header">
		<a href="/admin/groups" class="back-link">← Groups</a>
		<h1>
			<span class="group-icon">◈</span>
			{data.group.name}
		</h1>
	</div>

	<div class="stat-card">
		<span class="stat-value">{data.members.length}</span>
		<span class="stat-label">Members</span>
	</div>

	{#if data.members.length > 0}
		<div class="members-grid">
			{#each data.members as member}
				<a href="/admin/users/{member.id}/stats" class="member-card">
					<span class="member-name">{member.name}</span>
					<span class="arrow">→</span>
				</a>
			{/each}
		</div>
	{:else}
		<div class="empty-state">
			<p>No members yet</p>
			<span>Add users to this group from the user stats page</span>
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
		flex-direction: column;
		gap: 0.5rem;
	}

	.back-link {
		font-size: 0.85rem;
		color: #666;
		transition: color 0.15s ease;
	}

	.back-link:hover {
		color: #9cc1cf;
	}

	.page-header h1 {
		display: flex;
		align-items: center;
		gap: 0.75rem;
		margin: 0;
		font-size: 1.5rem;
		font-weight: 300;
	}

	.group-icon {
		color: #9cc1cf;
		font-size: 1.25rem;
	}

	.stat-card {
		background: #1f1f1f;
		border: 1px solid #2a2a2a;
		border-radius: 10px;
		padding: 1rem 1.25rem;
		display: flex;
		flex-direction: column;
		gap: 0.25rem;
		width: fit-content;
	}

	.stat-value {
		font-size: 1.75rem;
		font-weight: 400;
		color: #9cc1cf;
	}

	.stat-label {
		font-size: 0.75rem;
		color: #666;
		text-transform: uppercase;
		letter-spacing: 0.5px;
	}

	.members-grid {
		display: flex;
		flex-direction: column;
		gap: 0.5rem;
	}

	.member-card {
		display: flex;
		justify-content: space-between;
		align-items: center;
		padding: 1rem 1.25rem;
		background: #1a1a1a;
		border: 1px solid #2a2a2a;
		border-radius: 10px;
		transition: all 0.15s ease;
	}

	.member-card:hover {
		background: #1f1f1f;
		border-color: #3a3a3a;
	}

	.member-name {
		font-size: 0.95rem;
	}

	.arrow {
		color: #555;
		font-size: 1.1rem;
		transition: transform 0.15s ease;
	}

	.member-card:hover .arrow {
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
