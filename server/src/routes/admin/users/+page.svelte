<script>
	import { goto } from '$app/navigation';
	import { page } from '$app/stores';
	import { Role } from '$lib/db/role';

	export let data;

	let searchInput = data.filters.search;
	let searchTimeout = /** @type {ReturnType<typeof setTimeout> | null} */ (null);

	/**
	 * @param {string} key
	 * @param {string} value
	 */
	function updateFilter(key, value) {
		const url = new URL($page.url);
		if (value) {
			url.searchParams.set(key, value);
		} else {
			url.searchParams.delete(key);
		}
		url.searchParams.delete('page');
		goto(url.toString(), { replaceState: true, invalidateAll: true });
	}

	/**
	 * @param {Event & {currentTarget: HTMLInputElement}} e
	 */
	function handleSearch(e) {
		const value = e.currentTarget.value;
		if (searchTimeout) clearTimeout(searchTimeout);
		searchTimeout = setTimeout(() => {
			updateFilter('search', value);
		}, 300);
	}

	/**
	 * @param {number} newPage
	 */
	function goToPage(newPage) {
		const url = new URL($page.url);
		if (newPage > 1) {
			url.searchParams.set('page', String(newPage));
		} else {
			url.searchParams.delete('page');
		}
		goto(url.toString(), { replaceState: true, invalidateAll: true });
	}
</script>

<section>
	<div class="page-header">
		<h1>Users</h1>
		<span class="count">{data.totalUsers} total</span>
	</div>

	<div class="filters">
		<div class="search-box">
			<input type="text" placeholder="Search users..." bind:value={searchInput} on:input={handleSearch} />
		</div>
		<select value={data.filters.role} on:change={(e) => updateFilter('role', e.currentTarget.value)}>
			<option value="">All roles</option>
			<option value={Role.SUPER_ADMIN}>Super Admin</option>
			<option value={Role.ADMIN}>Admin</option>
			<option value={Role.USER}>User</option>
		</select>
	</div>

	{#if data.users.length > 0}
		<div class="users-grid">
			{#each data.users as user}
				<a href="/admin/users/{user.id}/stats" class="user-card">
					<div class="user-info">
						<span class="username">{user.username}</span>
						<span class="role-badge" class:admin={user.role !== Role.USER} class:super={user.role === Role.SUPER_ADMIN}>
							{user.role === Role.SUPER_ADMIN ? 'Super Admin' : user.role === Role.ADMIN ? 'Admin' : 'User'}
						</span>
					</div>
					<span class="arrow">→</span>
				</a>
			{/each}
		</div>

		{#if data.pagination.totalPages > 1}
			<div class="pagination">
				<button class="page-btn" disabled={data.pagination.page <= 1} on:click={() => goToPage(data.pagination.page - 1)}>
					← Prev
				</button>
				<div class="page-info">
					<span class="current">Page {data.pagination.page}</span>
					<span class="total">of {data.pagination.totalPages}</span>
				</div>
				<button class="page-btn" disabled={data.pagination.page >= data.pagination.totalPages} on:click={() => goToPage(data.pagination.page + 1)}>
					Next →
				</button>
			</div>
		{/if}

		<div class="results-info">
			Showing {(data.pagination.page - 1) * data.pagination.pageSize + 1}-{Math.min(data.pagination.page * data.pagination.pageSize, data.pagination.total)} of {data.pagination.total} users
		</div>
	{:else}
		<div class="empty-state">
			<p>No users found</p>
			<span>Try adjusting your search or filters</span>
		</div>
	{/if}
</section>

<style>
	section {
		display: flex;
		flex-direction: column;
		gap: 1.5rem;
		width: 100%;
		max-width: 900px;
		padding-bottom: 2rem;
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

	.filters {
		display: flex;
		gap: 1rem;
		flex-wrap: wrap;
	}

	.search-box {
		flex: 1;
		min-width: 200px;
	}

	.search-box input {
		width: 100%;
		padding: 0.75rem 1rem;
		background: #1f1f1f;
		border: 1px solid #2a2a2a;
		border-radius: 8px;
		color: #e0e0e0;
		font-size: 0.9rem;
		font-family: inherit;
		box-sizing: border-box;
	}

	.search-box input:focus {
		outline: none;
		border-color: #9cc1cf;
	}

	.search-box input::placeholder {
		color: #555;
	}

	select {
		padding: 0.75rem 1rem;
		background: #1f1f1f;
		border: 1px solid #2a2a2a;
		border-radius: 8px;
		color: #e0e0e0;
		font-size: 0.9rem;
		font-family: inherit;
		cursor: pointer;
	}

	select:focus {
		outline: none;
		border-color: #9cc1cf;
	}

	.users-grid {
		display: flex;
		flex-direction: column;
		gap: 0.5rem;
	}

	.user-card {
		display: flex;
		justify-content: space-between;
		align-items: center;
		padding: 1rem 1.25rem;
		background: #1a1a1a;
		border: 1px solid #2a2a2a;
		border-radius: 10px;
		transition: all 0.15s ease;
	}

	.user-card:hover {
		background: #1f1f1f;
		border-color: #3a3a3a;
	}

	.user-info {
		display: flex;
		align-items: center;
		gap: 1rem;
		min-width: 0;
	}

	.username {
		font-size: 0.95rem;
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;
	}

	.role-badge {
		font-size: 0.7rem;
		padding: 0.25rem 0.5rem;
		border-radius: 4px;
		background: #2a2a2a;
		color: #888;
		text-transform: uppercase;
		letter-spacing: 0.5px;
		flex-shrink: 0;
	}

	.role-badge.admin {
		background: #9cc1cf20;
		color: #9cc1cf;
	}

	.role-badge.super {
		background: #ecfbc720;
		color: #ecfbc7;
	}

	.arrow {
		color: #555;
		font-size: 1.1rem;
		transition: transform 0.15s ease;
	}

	.user-card:hover .arrow {
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

	.pagination {
		display: flex;
		justify-content: center;
		align-items: center;
		gap: 1.5rem;
		padding: 1.5rem;
		background: #1a1a1a;
		border: 1px solid #2a2a2a;
		border-radius: 12px;
		margin-top: 1rem;
	}

	.page-btn {
		padding: 0.6rem 1.25rem;
		background: #2a2a2a;
		border-radius: 8px;
		font-size: 0.9rem;
		color: #e0e0e0;
		transition: all 0.15s ease;
	}

	.page-btn:hover:not(:disabled) {
		background: #3a3a3a;
		color: #9cc1cf;
	}

	.page-btn:disabled {
		opacity: 0.3;
		cursor: not-allowed;
	}

	.page-info {
		display: flex;
		flex-direction: column;
		align-items: center;
		gap: 0.25rem;
	}

	.page-info .current {
		font-size: 0.95rem;
		font-weight: 500;
		color: #e0e0e0;
	}

	.page-info .total {
		font-size: 0.75rem;
		color: #666;
	}

	.results-info {
		text-align: center;
		font-size: 0.8rem;
		color: #555;
		margin-top: 1rem;
	}
</style>
