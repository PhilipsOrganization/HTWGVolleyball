<script>
	import { enhance } from '$app/forms';
	import Course from '$lib/components/course.svelte';
	import { humanReadableDate } from '$lib/helpers/date';

	export let data;
	export let form;

	/** @type {number} */
	let courseID;
</script>

<h1>New Course</h1>
<form method="POST" action="?/create-course" use:enhance>
	<field>
		<label for="name">Name</label>
		<input type="text" name="name" placeholder="Name" value="test" />
		<small class="error">{form?.name}</small>
	</field>

	<field>
		<label for="location">Location</label>
		<input type="text" name="location" placeholder="Location" value="test location" />
		<small class="error">{form?.location}</small>
	</field>

	<field>
		<label for="date">Date</label>
		<input type="date" name="date" placeholder="Date" />
		<small class="error">{form?.date}</small>
	</field>

	<field>
		<label for="time">Time</label>
		<input type="time" name="time" placeholder="Time" />
		<small class="error">{form?.time}</small>
	</field>

	<field>
		<label for="maxParticipants">Max Participants</label>
		<input type="number" name="maxParticipants" placeholder="Max Participants" value={10} />
		<small class="error">{form?.maxParticipants}</small>
	</field>

	<field>
		<label for="publishOn">Publish On</label>
		<input type="datetime-local" name="publishOn" placeholder="Publish On" />
		<small class="error">{form?.publishOn}</small>
	</field>

	<button>Submit</button>
</form>

<h1>Courses</h1>
<div id="list">
	{#each data.dates ?? [] as block, i}
		<span>{humanReadableDate(block.date)}</span>
		{#each block.courses as course}
			<Course
				{course}
				on:select={(c) => (courseID = c.detail.course)}
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

<h1>Users</h1>
{#each data.users as user}
	<div>
		<p>{user.username}</p>
		<b>{user.role}</b>
		{#if user.role === 'admin'}
			<form action="?/demote" method="post">
				<input type="hidden" name="userId" value={user.id} />
				<button>demote to user</button>
			</form>
		{:else}
			<form action="?/promote" method="post">
				<input type="hidden" name="userId" value={user.id} />
				<button>promote to admin</button>
			</form>
		{/if}
	</div>
{/each}

<style>
	h1 {
		text-align: center;
	}

	form {
		display: flex;
		flex-direction: column;
		max-width: 400px;
		margin: 2rem auto;
	}

	form field {
		display: flex;
		flex-direction: column;
		margin-bottom: 1rem;
	}

	form field label {
		margin-bottom: 0.5rem;
	}

	form field input {
		padding: 0.5rem;
		border: 1px solid #ccc;
		border-radius: 0.25rem;
	}

	form field input:focus {
		outline: none;
		border-color: #000;
	}

	form button {
		padding: 0.5rem;
		border: 1px solid #ccc;
		border-radius: 0.25rem;
	}

	#list {
		max-height: 48dvh;
		overflow-y: auto;
		margin-bottom: 4vh;
		width: 800px;
		max-width: 70vw;
		margin: 0 auto;
	}
</style>
