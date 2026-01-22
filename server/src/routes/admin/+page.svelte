<script>
	import { goto } from '$app/navigation';
	import { page } from '$app/stores';
	import Course from '$lib/components/course.svelte';
	import CreateCourse from '$lib/components/createCourse.svelte';
	import { humanReadableDate } from '$lib/helpers/date';

	export let data;

	/** @param {Event & {currentTarget: EventTarget & HTMLInputElement}} event  */
	function toggleShowArchived(event) {
		const show = event.currentTarget.checked;
		const url = new URL($page.url);
		show ? url.searchParams.set('archived', 'true') : url.searchParams.delete('archived');
		url.searchParams.delete('page');
		goto(url.toString(), { replaceState: true, invalidateAll: true });
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

<CreateCourse templates={data.courseTemplates} groups={data.groups} />
<main>
	<div class="page-header">
		<h1>Course Management</h1>
		<div class="header-actions">
			<span class="total-count">{data.pagination.totalItems} courses</span>
			<label class="toggle">
				<input type="checkbox" id="archived" checked={$page.url.searchParams.has('archived')} on:change={(e) => toggleShowArchived(e)} />
				<span>Show archived</span>
			</label>
		</div>
	</div>

	<div class="stats-row">
		<div class="stat-card">
			<span class="stat-value">{data.pagination.totalItems}</span>
			<span class="stat-label">Total Courses</span>
		</div>
		<div class="stat-card">
			<span class="stat-value">{data.courseTemplates?.length ?? 0}</span>
			<span class="stat-label">Templates</span>
		</div>
		<div class="stat-card">
			<span class="stat-value">{data.groups?.length ?? 0}</span>
			<span class="stat-label">Groups</span>
		</div>
	</div>

	<div id="list">
		{#each data.dates ?? [] as block}
			<div class="date-block">
				<h2>{humanReadableDate(block.date)}</h2>
				{#each block.courses as course, i}
					<Course {course} admin isFirst={i === 0} />
				{/each}
			</div>
		{/each}
		{#if data.dates?.length === 0}
			<div class="empty-state">
				<p>No courses found</p>
				<span>Create a new course using the button below</span>
			</div>
		{/if}
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
</main>

<style>
	main {
		display: flex;
		flex-direction: column;
		margin: 0 auto;
		width: 100%;
		max-width: 800px;
		box-sizing: border-box;
		padding-bottom: 2rem;
	}

	.page-header {
		display: flex;
		justify-content: space-between;
		align-items: center;
		margin-bottom: 1.5rem;
		flex-wrap: wrap;
		gap: 1rem;
	}

	.header-actions {
		display: flex;
		align-items: center;
		gap: 1.5rem;
	}

	.total-count {
		font-size: 0.875rem;
		color: #666;
	}

	.page-header h1 {
		margin: 0;
		font-size: 1.5rem;
		font-weight: 300;
		color: #e0e0e0;
	}

	.toggle {
		display: flex;
		align-items: center;
		gap: 0.5rem;
		cursor: pointer;
		font-size: 0.875rem;
		color: #888;
	}

	.toggle input {
		width: 1rem;
		height: 1rem;
		accent-color: #9cc1cf;
	}

	.toggle:hover {
		color: #e0e0e0;
	}

	.stats-row {
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
		gap: 1rem;
		margin-bottom: 2rem;
	}

	.stat-card {
		background: #1f1f1f;
		border: 1px solid #2a2a2a;
		border-radius: 10px;
		padding: 1rem 1.25rem;
		display: flex;
		flex-direction: column;
		gap: 0.25rem;
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

	#list {
		display: flex;
		flex-direction: column;
		gap: 1.5rem;
		margin-bottom: 2rem;
	}

	.date-block {
		display: flex;
		flex-direction: column;
		border-radius: 12px;
		background: #1a1a1a;
		border: 1px solid #2a2a2a;
		overflow: hidden;
	}

	.date-block h2 {
		text-align: center;
		margin: 0;
		padding: 1rem;
		text-transform: capitalize;
		letter-spacing: 0.5px;
		font-weight: 300;
		font-size: 1rem;
		background: #1f1f1f;
		color: #9cc1cf;
		border-bottom: 1px solid #2a2a2a;
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
</style>
