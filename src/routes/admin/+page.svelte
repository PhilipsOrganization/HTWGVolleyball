<script>
	import { afterNavigate, goto } from '$app/navigation';
	import { page } from '$app/stores';
	import Course from '$lib/components/course.svelte';
	import CreateCourse from '$lib/components/createCourse.svelte';
	import { humanReadableDate } from '$lib/helpers/date';

	export let data;

	/** @type {number} */
	$: courseID = parseInt($page.url.searchParams.get('course') ?? '0');
</script>

<CreateCourse />

<h1>Courses <a href="/admin/users">Manage Users</a></h1>
<div id="list">
	{#each data.dates ?? [] as block, i}
		<span>{humanReadableDate(block.date)}</span>
		{#each block.courses as course}
			<Course
				{course}
				on:select={(c) =>
					goto(`/admin?course=${c.detail.course}`, { invalidateAll: true, replaceState: true })}
				selected={course.id === courseID}
				action="?/delete-course"
				actionName="delete"
				showPublishDate
			/>
		{/each}
		{#if i < data.dates?.length - 1}
			<div class="line" />
		{/if}
	{/each}
	{#if data.dates?.length === 0}There are currently no courses. ☹{/if}
</div>

<div id="users">
	{#if data.course}
		<h2>
			Participants for {data.course.name}
			{humanReadableDate(data.course.date)},{data.course.time}
		</h2>

		{#each data.course.participants ?? [] as participant}
			<div class="user">
				<span>{participant.username}</span>
				<a href="/admin/users/{participant.id}/stats">&#9432;</a>
				<form action="?/cancel" method="post">
					<input type="hidden" name="userId" value={participant.id} />
					<input type="hidden" name="courseId" value={courseID} />
					<button>cancel</button>
				</form>
			</div>
		{:else}
			<p>There are currently no participants. ☹</p>
		{/each}
	{/if}
</div>

<style>
	h1 {
		text-align: center;
	}

	#list {
		width: 800px;
		max-width: 70vw;
		margin: 0 auto;
	}

	#users {
		width: 800px;
		max-width: 70vw;
		margin: 20px auto;
	}

	.user {
		display: flex;
		justify-content: space-between;
		align-items: center;
		background: rgb(228, 228, 228);
		padding: 10px;
		border-radius: 5px;
		margin: 5px 0;
	}

	a {
		text-decoration: none;
	}

	button {
		background: none;
		border: none;
		cursor: pointer;
		padding: 10px;
		border: 1px solid red;
		border-radius: 5px;
		color: red;
	}
</style>
