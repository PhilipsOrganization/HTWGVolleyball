<script>
	import ConfirmableForm from '$lib/components/confirmable-form.svelte';
	import { Role } from '$lib/db/role';
	import { draw } from 'svelte/transition';

	export let data;

	const user = data.user;

	/**
	 *
	 * @param date {Date}
	 */
	function format(date) {
		return new Intl.DateTimeFormat('de-DE', {
			weekday: 'long',
			year: 'numeric',
			month: 'numeric',
			day: 'numeric'
		}).format(date);
	}

	async function copyResetPasswordLink() {
		const req = await fetch(`/admin/users/${user.id}/reset-pw`, {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json'
			},
			body: user.id + ''
		});

		const url = new URL(window.location.href);
		const { link } = await req.json();
		await navigator.clipboard.writeText(url.origin + link);
	}
</script>

<section>
	<h1>Stats for {user.username}</h1>

	<div>
		{#if user.role === Role.ADMIN}
			<ConfirmableForm message="Do you really want to demote the user to a normie?">
				<form action="?/demote" method="post" slot="confirm">
					<button>demote to user</button>
				</form>
				<button slot="button">demote to user</button>
			</ConfirmableForm>
		{:else if user.role === Role.USER}
			<ConfirmableForm message="Do you really want to promote the user to an admin?">
				<form action="?/promote" method="post" slot="confirm">
					<button>promote to admin</button>
				</form>
				<button slot="button">promote to admin</button>
			</ConfirmableForm>
		{/if}
		<form action="?/reset-pw" method="post">
			<button>Send Password Reset Email</button>
		</form>
		{#if user.role === Role.USER}
			<ConfirmableForm message="Do you really want to delete the user?">
				<form action="?/delete" method="post" slot="confirm">
					<button>Delete User</button>
				</form>
				<button slot="button">Delete User</button>
			</ConfirmableForm>
		{/if}
	</div>
	<br />
	<div class="column">
		<p>Registered: {format(user.createdAt)}</p>
		<p>Last Login: {format(user.lastLogin)}</p>
	</div>

	<br />
	<div>
		<p class="red">Number of Strikes: {user.strikes}</p>
		{#if user.strikes > 0}
			<form action="?/unstrike" method="post">
				<button class="small">remove</button>
			</form>
		{/if}
	</div>
	<br />
	<p>Registered for {data.totalRegistrations} Courses</p>
	{#each data.stats as course}
		<p>{course.courseName}: {course.count}</p>
	{:else}
		<p>No courses registered</p>
	{/each}
</section>

<div class="center">
	<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
		<path in:draw={{ duration: 1000 }} fill="none" stroke="grey" d={data.svg} />
	</svg>
</div>
<br />
<div class="column">
	<h2>Notes</h2>
	<form class="flex" method="post" action="?/note">
		<textarea name="notes" id="notes" cols="30" rows="10" value={user.notes} />
		<button>Save</button>
	</form>
</div>

<style>
	section {
		display: flex;
		flex-direction: column;
		padding: 1rem;
		gap: 0px;
	}

	p {
		margin: 0;
	}

	div {
		display: flex;
		flex-direction: row;
		align-items: center;
	}

	div.center {
		justify-content: center;
		margin: 1rem;
		width: 80%;
		height: 200px;
	}

	div.column {
		flex-direction: column;
		align-items: flex-start;
	}

	svg {
		width: 100%;
		height: 100%;
	}

	button {
		padding: 20px;
		background: #9cc1cf;
		margin: 10px;
		color: black;
	}

	.red {
		color: #ecfbc7;
	}

	.small {
		padding: 10px;
		background: #ecfbc7;
	}

	.flex {
		display: flex;
	}
</style>
