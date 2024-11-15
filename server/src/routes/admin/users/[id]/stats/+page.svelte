<script>
	import { enhance } from '$app/forms';
	import ConfirmableForm from '$lib/components/confirmable-form.svelte';
	import { Role } from '$lib/db/role';
	import { approximatelyFormatTime } from '$lib/helpers/date';
	import { addToast } from '$lib/helpers/toast';

	export let data;
	export let form;

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

	/**
	 * @param {{formElement: HTMLFormElement}} param0
	 * @returns {(data: {result: any}) => void}
	 */
	function updateEmailStatus({ formElement }) {
		return ({ result }) => {
			if (result.type === 'success') {
				addToast('success', 'Email sent successfully');
				formElement.reset();
			}

			if (result.type === 'failure') {
				addToast('error', 'Email failed to send');
			}

			form = result.data;
		};
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
	{#if data.registrationStats}
		<p>Average Registration time: {approximatelyFormatTime(data.registrationStats.avg)}</p>
		<p>Fastest Registration time: {approximatelyFormatTime(data.registrationStats.min)}</p>
	{/if}
</section>
<section>
	<h2>Groups</h2>
	{#if user.role === Role.USER}
		<form action="?/update-groups" method="POST" class="column flex" use:enhance>
			<label for="groups"> Select the groups the user should be a member of: </label>
			<select name="groups" multiple id="groups">
				{#each data.groups as group}
					<option value={group.id} selected={!!group.isMember}>{group.name}</option>
				{/each}
			</select>

			<button type="submit">Update Groups</button>
		</form>
	{:else}
		<p>User is an admin and is automatically in all groups.</p>
	{/if}
</section>
<section>
	<h2>Send {user.username} an email message:</h2>
	<form action="?/sendEmail" method="post" id="email" use:enhance={updateEmailStatus}>
		<label for="subject">Subject</label>
		<input type="text" name="subject" autocomplete="off" value={form?.subject ?? ''} placeholder="Email Subject Line" id="subject" />
		<label for="message">Message</label>
		<textarea name="message" id="message" cols="30" rows="10" value={form?.body ?? ''} placeholder="Email Body" />
		{#if form?.error}
			<div id="error">
				<p>Error: {form.error}!</p>
			</div>
		{/if}
		<button>Send Email</button>
	</form>
</section>

<!-- <div class="center">
	<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
		<path in:draw={{ duration: 1000 }} fill="none" stroke="grey" d={data.svg} />
	</svg>
</div> -->
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

	.column {
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

	#email {
		display: flex;
		flex-direction: column;
		width: min(800px, 90vw);
		margin: 10px 5px;
		font-size: 1.2rem;
	}

	#error {
		color: #ffffff;
		border: 1px solid #f95462;
		padding: 10px;
		margin: 0 10px;
		border-radius: 5px;
	}

	#error p {
		margin: 0;
		text-align: center;
		width: 100%;
	}

	label {
		margin: 10px 0;
		padding-left: 10px;
	}

	input,
	textarea {
		padding: 10px;
		margin: 10px;
		border-radius: 5px;
		border: 1px solid #ccc;
	}

	label {
		margin: 6px 0;
	}

	option {
		background: #1f1f1f;
		color: #fff;
		font-size: 16px;
		padding: 10px;
	}

	option[selected] {
		background: #9ccfa8;
	}

	select {
		padding: 10px;
		margin: 10px;
		border-radius: 5px;
		border: 1px solid #ccc;
		width: min(90%, 370px);
		background: 0;
		overflow: auto;
	}
</style>
