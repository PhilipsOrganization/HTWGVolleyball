<script>
	import { enhance } from '$app/forms';
	import { max } from 'date-fns';

	export let data;
	export let form;

	/**
	 * @param {number} day
	 */
	function numberToDay(day) {
		switch (day) {
			case 1:
				return 'Monday';
			case 2:
				return 'Tuesday';
			case 3:
				return 'Wednesday';
			case 4:
				return 'Thursday';
			case 5:
				return 'Friday';
			case 6:
				return 'Saturday';
			case 0:
				return 'Sunday';
			default:
				return 'Unknown';
		}
	}
</script>

<h1>Course Templates</h1>

<div class="grid">
	{#each data.courseTemplates as template}
		<div class="card">
			<h2>{template.name}</h2>
			<p>Location: {template.location}</p>
			<p>{numberToDay(template.day)}s at {template.time}</p>
			<p>Max Participants: {template.maxParticipants}</p>
			<p>Publish On: {numberToDay(template.publishDay)}s at {template.publishHour}:00</p>
			{#if template.maxStrikes === 0}
				<p>Max Strikes: No Limit</p>
			{:else}
				<p>Max Strikes: {template.maxStrikes}</p>
			{/if}
			<p>
				Allow Double Bookings:
				{template.allowDoubleBookings}
			</p>
			<p>
				Auto Create:
				{template.autoCreate}
			</p>
			{#if template.groupId !== null}
				<p>Group: {template.group?.name}</p>
			{/if}

			{#if template.autoCreate}
				{#if data.globalUser.id === template.trainer}
					<b>You are the Trainer</b>
					<br />
					<small> You will get automatically assigned to each course created from this template. </small>
				{:else}
					{#if template.trainerName}
						<b>Trainer: {template.trainerName}</b>
					{/if}
					<form action="?/assign" method="post" use:enhance>
						<input type="hidden" name="templateId" value={template.id} />
						<button>Assign Me as Trainer</button>
					</form>
				{/if}
			{/if}

			<form action="?/delete" method="post" use:enhance>
				<input type="hidden" name="templateId" value={template.id} />
				<button class="delete">Delete</button>
			</form>
		</div>
	{/each}
</div>

<details>
	<summary> Create Course Template </summary>
	<form action="?/create" method="post" use:enhance>
		<field>
			<label for="name">Name</label>
			<input type="text" name="name" placeholder="Course Name" required />
		</field>

		<field>
			<label for="location">Location</label>
			<input type="text" name="location" value="Ellenrieder Sporthalle" required />
		</field>

		<field>
			<label for="day">Day</label>
			<select name="day" id="day" class="pad" required>
				<option value="" disabled selected>Select a Day</option>
				<option value="1">Monday</option>
				<option value="2">Tuesday</option>
				<option value="3">Wednesday</option>
				<option value="4">Thursday</option>
				<option value="5">Friday</option>
				<option value="6">Saturday</option>
				<option value="0">Sunday</option>
			</select>
		</field>

		<field>
			<label for="time">Time</label>
			<input type="time" name="time" placeholder="Time" required />
		</field>

		<field>
			<label for="maxParticipants">Max Participants</label>
			<input type="number" name="maxParticipants" value="18" required />
		</field>

		<field>
			<label for="publishDay">Publish On</label>
			<select name="publishDay" id="publishDay" class="pad" required>
				<option value="1">Monday</option>
				<option value="2">Tuesday</option>
				<option value="3">Wednesday</option>
				<option value="4" selected>Thursday</option>
				<option value="5">Friday</option>
				<option value="6">Saturday</option>
				<option value="0">Sunday</option>
			</select>
		</field>

		<field>
			<label for="publishHour">Publish Hour</label>
			<input type="number" name="publishHour" value="12" required />
		</field>

		<field>
			<label for="maxStrikes">Max Strikes</label>
			<input type="number" name="maxStrikes" value="3" required />
			<small> Number of strikes a user is allowed to have to participate. 0 means no limit. </small>
		</field>

		<field>
			<label class="center">
				Allow Users to Book Multiple Courses
				<input type="checkbox" name="allowDoubleBookings" />
			</label>
		</field>

		<field>
			<label class="center">
				Auto Generate Course each Week
				<input type="checkbox" name="autoCreate" />
			</label>
		</field>

		<field>
			<label for="group">
				Select a user group the course should be visible to:
				<select name="groupId" id="group" class="pad">
					<option value="" selected>Show to all Users</option>
					{#each data.groups as group}
						<option value={group.id}>{group.name}</option>
					{/each}
				</select>
			</label>
		</field>

		<button id="submit">Submit</button>

		{#if form}
			<p class="error">{JSON.stringify(form.body?.errors)}</p>
		{/if}
	</form>
</details>

<style>
	h1 {
		margin-left: 1rem;
	}

	details {
		margin: 1rem auto;
		border: 1px solid #5d5d5d;
		width: min(95%, 500px);
		padding: 2rem 0;
		border-radius: 0.25rem;
	}

	summary {
		color: #e0e0e0;
		text-align: center;
		font-weight: 900;
		text-transform: uppercase;
		letter-spacing: 1.1px;
		padding: 1rem 0;
		cursor: pointer;
	}

	#submit {
		min-width: 60%;
	}

	form {
		display: flex;
		flex-direction: column;
		padding: 1rem;
	}

	form field {
		display: flex;
		flex-direction: column;
		margin-bottom: 1rem;
	}

	form field label {
		margin-bottom: 0.5rem;
	}

	form field input,
	form field select {
		padding: 0.5rem;
		border: 1px solid #ccc;
		border-radius: 0.25rem;
		color: #e0e0e0;
	}

	input,
	select,
	option {
		background: #1f1f1f;
		color: #fff;
		font-size: 16px;
	}

	form field input:focus {
		outline: none;
		border-color: #000;
	}

	#submit {
		background: #9cc1cf;
		color: #000;
		padding: 1rem 2rem;
		text-align: center;
	}

	.center {
		display: flex;
		justify-content: space-between;
		align-items: center;
	}

	select.pad {
		padding: 0.5rem;
		display: inline-block;
		margin: 0.4rem 0;
	}

	div.grid {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
		gap: 1rem;
		padding: 2rem;
	}

	div.card {
		background-color: #1f1f1f;
		padding: 1rem;
		border-radius: 0.25rem;
		border: 1px solid #5d5d5d;
		max-width: calc(100vw - 7rem);
	}

	button.delete {
		background-color: #eb714f;
		color: #000;
	}

	button {
		background: #ecfbc7;
		color: #000;
		padding: 0.5rem 1rem;
		margin: 0.5rem 0;
	}
</style>
