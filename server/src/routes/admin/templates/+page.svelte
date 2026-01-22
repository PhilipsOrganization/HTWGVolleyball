<script lang="ts">
	import { enhance } from '$app/forms';

	let { data, form } = $props();

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

<section>
	<div class="page-header">
		<h1>Course Templates</h1>
		<span class="count">{data.courseTemplates.length} templates</span>
	</div>

	<details class="create-section">
		<summary>
			<span class="plus">+</span> Create New Template
		</summary>
		<form action="?/create" method="post" use:enhance>
			<div class="form-grid">
				<div class="field">
					<label for="name">Name</label>
					<input type="text" name="name" id="name" placeholder="Course Name" required />
				</div>

				<div class="field">
					<label for="location">Location</label>
					<input type="text" name="location" id="location" value="Ellenrieder Sporthalle" required />
				</div>

				<div class="field">
					<label for="day">Day</label>
					<select name="day" id="day" required>
						<option value="" disabled selected>Select a Day</option>
						<option value="1">Monday</option>
						<option value="2">Tuesday</option>
						<option value="3">Wednesday</option>
						<option value="4">Thursday</option>
						<option value="5">Friday</option>
						<option value="6">Saturday</option>
						<option value="0">Sunday</option>
					</select>
				</div>

				<div class="field">
					<label for="time">Time</label>
					<input type="time" name="time" id="time" required />
				</div>

				<div class="field">
					<label for="maxParticipants">Max Participants</label>
					<input type="number" name="maxParticipants" id="maxParticipants" value="18" required />
				</div>

				<div class="field">
					<label for="publishDay">Publish Day</label>
					<select name="publishDay" id="publishDay" required>
						<option value="1">Monday</option>
						<option value="2">Tuesday</option>
						<option value="3">Wednesday</option>
						<option value="4" selected>Thursday</option>
						<option value="5">Friday</option>
						<option value="6">Saturday</option>
						<option value="0">Sunday</option>
					</select>
				</div>

				<div class="field">
					<label for="publishHour">Publish Hour</label>
					<input type="number" name="publishHour" id="publishHour" value="12" required />
				</div>

				<div class="field">
					<label for="maxStrikes">Max Strikes</label>
					<input type="number" name="maxStrikes" id="maxStrikes" value="3" required />
					<small>0 = no limit</small>
				</div>

				<div class="field">
					<label for="group">Visible To</label>
					<select name="groupId" id="group">
						<option value="" selected>All Users</option>
						{#each data.groups as group}
							<option value={group.id}>{group.name}</option>
						{/each}
					</select>
				</div>
			</div>

			<div class="checkbox-row">
				<label class="checkbox-label">
					<input type="checkbox" name="allowDoubleBookings" />
					<span>Allow Double Bookings</span>
				</label>
				<label class="checkbox-label">
					<input type="checkbox" name="autoCreate" />
					<span>Auto Generate Weekly</span>
				</label>
			</div>

			<button type="submit" class="submit-btn">Create Template</button>

			{#if form}
				<p class="error">{JSON.stringify(form.body?.errors)}</p>
			{/if}
		</form>
	</details>

	{#if data.courseTemplates.length > 0}
		<div class="templates-grid">
			{#each data.courseTemplates as template}
				<div class="template-card">
					<div class="card-header">
						<h2>{template.name}</h2>
						<div class="badges">
							{#if template.autoCreate}
								<span class="badge auto">Auto</span>
							{/if}
							{#if template.groupId}
								<span class="badge group">{template.group?.name}</span>
							{/if}
						</div>
					</div>

					<div class="card-body">
						<div class="info-row">
							<span class="label">Schedule</span>
							<span class="value">{numberToDay(template.day)}s at {template.time}</span>
						</div>
						<div class="info-row">
							<span class="label">Location</span>
							<span class="value">{template.location}</span>
						</div>
						<div class="info-row">
							<span class="label">Max Participants</span>
							<span class="value">{template.maxParticipants}</span>
						</div>
						<div class="info-row">
							<span class="label">Publish</span>
							<span class="value">{numberToDay(template.publishDay)}s at {template.publishHour}:00</span>
						</div>
						<div class="info-row">
							<span class="label">Max Strikes</span>
							<span class="value">{template.maxStrikes === 0 ? 'No Limit' : template.maxStrikes}</span>
						</div>
						<div class="info-row">
							<span class="label">Double Bookings</span>
							<span class="value">{template.allowDoubleBookings ? 'Allowed' : 'Not Allowed'}</span>
						</div>
					</div>

					{#if template.autoCreate}
						<div class="trainer-section">
							{#if data.globalUser.id === template.trainer}
								<div class="trainer-info self">
									<span>You are the Trainer</span>
								</div>
							{:else}
								{#if template.trainerName}
									<div class="trainer-info">
										<span>Trainer: {template.trainerName}</span>
									</div>
								{/if}
								<form action="?/assign" method="post" use:enhance>
									<input type="hidden" name="templateId" value={template.id} />
									<button class="assign-btn">Assign Me</button>
								</form>
							{/if}
						</div>
					{/if}

					<div class="card-actions">
						<form action="?/delete" method="post" use:enhance>
							<input type="hidden" name="templateId" value={template.id} />
							<button class="delete-btn">Delete</button>
						</form>
					</div>
				</div>
			{/each}
		</div>
	{:else}
		<div class="empty-state">
			<p>No templates yet</p>
			<span>Create your first course template above</span>
		</div>
	{/if}
</section>

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

	.templates-grid {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
		gap: 1.5rem;
		padding: 1rem 0;
	}

	.template-card {
		background-color: #1a1a1a;
		padding: 1.5rem;
		border-radius: 12px;
		border: 1px solid #2a2a2a;
		display: flex;
		flex-direction: column;
		gap: 1rem;
	}

	.card-header h2 {
		margin: 0;
		font-size: 1.25rem;
		font-weight: 400;
		color: #9cc1cf;
	}

	.card-actions {
		margin-top: auto;
		border-top: 1px solid #2a2a2a;
		padding-top: 1rem;
	}

	.delete-btn {
		background-color: #eb714f20 !important;
		color: #eb714f !important;
		border: 1px solid #eb714f40 !important;
		width: 100%;
		border-radius: 6px;
	}

	.delete-btn:hover {
		background-color: #eb714f40 !important;
	}

	button {
		background: #9cc1cf;
		color: #000;
		padding: 0.75rem 1rem;
		border-radius: 8px;
		font-weight: 500;
		transition: all 0.15s ease;
	}

	button:hover {
		background: #b0d1dc;
	}
</style>
