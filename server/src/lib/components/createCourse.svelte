<script>
	import { page } from '$app/stores';
	import { fade, scale } from 'svelte/transition';

	/**
	 * @type {import('$lib/db/schema').CourseTemplate[]}
	 */
	export let templates = [];
	/**
	 * @type {import('$lib/db/schema').Group[]}
	 */
	export let groups = [];
	$: form = $page.form;

	/**
	 * @type {string}
	 */
	let templateName = templates[0]?.name;
	$: template = templates.find((t) => t.name === templateName);

	/**
	 * @type {HTMLDialogElement}
	 */
	let dialogEl;

	/**
	 * @param {number} number
	 */
	function padNumberToTwoDigits(number) {
		return number.toString().padStart(2, '0');
	}

	/**
	 * @param {Date | undefined} date
	 */
	function dateTimeToDateString(date) {
		if (!date) return '';
		const components = [date.getFullYear(), padNumberToTwoDigits(date.getMonth() + 1), padNumberToTwoDigits(date.getDate())];
		return components.join('-');
	}

	/**
	 * @param {Date | undefined} date
	 */
	function dateTimeToString(date) {
		if (!date) return '';
		const components = [
			dateTimeToDateString(date),
			'T',
			padNumberToTwoDigits(date.getHours()),
			':',
			padNumberToTwoDigits(date.getMinutes())
		];
		return components.join('');
	}

	function closeDialog() {
		dialogEl.close();
	}
</script>

<button class="fab-btn" on:click={() => dialogEl.showModal()}>
	<span class="plus-icon">+</span>
	<span class="btn-text">Create Course</span>
</button>

<dialog bind:this={dialogEl} on:click|self={closeDialog}>
	<div class="dialog-content" in:scale={{ duration: 200, start: 0.95 }}>
		<header>
			<h1>New Course</h1>
			<button class="close-btn" on:click={closeDialog} aria-label="Close dialog">×</button>
		</header>

		<form method="POST" action="?/create-course">
			<div class="form-grid">
				<div class="field full">
					<label for="name">Template</label>
					<select bind:value={templateName} name="name" id="name">
						{#each templates as t}
							<option value={t.name}>{t.name}</option>
						{/each}
					</select>
					{#if form?.name}
						<small class="error">{form.name}</small>
					{/if}
				</div>

				<div class="field full">
					<label for="location">Location</label>
					<input value={template?.location ?? ''} type="text" name="location" id="location" placeholder="e.g. Sporthalle" />
					{#if form?.location}
						<small class="error">{form.location}</small>
					{/if}
				</div>

				<div class="field">
					<label for="date">Date</label>
					<input value={dateTimeToDateString(template?.date)} type="date" name="date" id="date" />
					{#if form?.date}
						<small class="error">{form.date}</small>
					{/if}
				</div>

				<div class="field">
					<label for="time">Time</label>
					<input value={template?.time ?? ''} type="time" name="time" id="time" />
					{#if form?.time}
						<small class="error">{form.time}</small>
					{/if}
				</div>

				<div class="field">
					<label for="maxParticipants">Max Participants</label>
					<input value={template?.maxParticipants ?? ''} type="number" name="maxParticipants" id="maxParticipants" />
					{#if form?.maxParticipants}
						<small class="error">{form.maxParticipants}</small>
					{/if}
				</div>

				<div class="field">
					<label for="publishOn">Publish On</label>
					<input value={dateTimeToString(template?.publishOn)} type="datetime-local" name="publishOn" id="publishOn" />
					{#if form?.publishOn}
						<small class="error">{form.publishOn}</small>
					{/if}
				</div>

				<div class="field full">
					<label for="group">Visibility</label>
					<select name="groupId" id="group" value={template?.groupId ?? ''}>
						<option value="">Show to all users</option>
						{#each groups as group}
							<option value={group.id}>{group.name}</option>
						{/each}
					</select>
				</div>

				<div class="field full checkbox-field">
					<label class="switch-label">
						<input type="checkbox" name="allowDoubleBookings" />
						<span class="switch" />
						<span class="label-text">Allow users to book multiple courses</span>
					</label>
				</div>
			</div>

			<footer class="form-footer">
				<button type="button" class="cancel-btn" on:click={closeDialog}>Cancel</button>
				<button type="submit" class="submit-btn">Create Course</button>
			</footer>
		</form>
	</div>
</dialog>

<style>
	* {
		box-sizing: border-box;
	}

	.fab-btn {
		position: fixed;
		bottom: 2rem;
		right: 2rem;
		z-index: 100;
		display: flex;
		align-items: center;
		gap: 0.75rem;
		padding: 0.75rem 1.5rem;
		background: #9cc1cf;
		color: #000;
		border-radius: 100px;
		box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
		transition: all 0.2s ease;
		font-weight: 500;
		border: none;
		cursor: pointer;
	}
	.fab-btn:hover {
		transform: translateY(-2px);
		background: #b0d1dc;
		box-shadow: 0 6px 16px rgba(0, 0, 0, 0.4);
	}
	.plus-icon {
		font-size: 1.5rem;
		line-height: 1;
	}
	dialog {
		padding: 0;
		background: transparent;
		border: none;
		max-width: 500px;
		width: 90%;
		outline: none;
		margin: auto;
	}
	dialog::backdrop {
		background: rgba(0, 0, 0, 0.7);
		backdrop-filter: blur(4px);
	}
	.dialog-content {
		background: #1f1f1f;
		border: 1px solid #333;
		border-radius: 16px;
		box-shadow: 0 20px 40px rgba(0, 0, 0, 0.5);
		overflow: hidden;
		width: 100%;
	}
	header {
		display: flex;
		justify-content: space-between;
		align-items: center;
		padding: 1.25rem 1.5rem;
		background: #252525;
		border-bottom: 1px solid #333;
	}
	header h1 {
		margin: 0;
		font-size: 1.25rem;
		font-weight: 400;
		color: #e0e0e0;
	}
	.close-btn {
		background: none;
		border: none;
		cursor: pointer;
		font-size: 1.5rem;
		line-height: 1;
		color: #888;
		padding: 0.25rem;
		transition: color 0.15s ease;
	}
	.close-btn:hover {
		color: #fff;
	}
	form {
		padding: 1.5rem;
		width: 100%;
	}
	.form-grid {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 1.25rem;
		width: 100%;
	}
	.field {
		display: flex;
		flex-direction: column;
		gap: 0.5rem;
		min-width: 0;
	}
	.field.full {
		grid-column: span 2;
	}
	label {
		font-size: 0.85rem;
		color: #aaa;
		font-weight: 400;
	}
	input,
	select {
		width: 100%;
		padding: 0.75rem;
		background: #151515;
		border: 1px solid #333;
		border-radius: 8px;
		color: #fff;
		font-size: 0.95rem;
		font-family: inherit;
		transition: border-color 0.15s ease;
	}
	input[type='checkbox'] {
		width: auto;
	}
	input:focus,
	select:focus {
		outline: none;
		border-color: #9cc1cf;
	}
	.checkbox-field {
		padding-top: 0.5rem;
	}
	.switch-label {
		display: flex;
		align-items: center;
		gap: 0.75rem;
		cursor: pointer;
		color: #e0e0e0;
	}
	.label-text {
		font-size: 0.9rem;
	}
	.error {
		color: #eb714f;
		font-size: 0.75rem;
		margin-top: 0.25rem;
	}
	.form-footer {
		display: flex;
		justify-content: flex-end;
		gap: 1rem;
		margin-top: 2rem;
		padding-top: 1.5rem;
		border-top: 1px solid #333;
	}
	.cancel-btn {
		background: none;
		border: none;
		cursor: pointer;
		padding: 0.75rem 1.5rem;
		color: #888;
		font-weight: 500;
		transition: color 0.15s ease;
	}
	.cancel-btn:hover {
		color: #fff;
	}
	.submit-btn {
		border: none;
		cursor: pointer;
		padding: 0.75rem 1.5rem;
		background: #9cc1cf;
		color: #000;
		border-radius: 8px;
		font-weight: 600;
		transition: transform 0.15s ease, background 0.15s ease;
	}
	.submit-btn:hover {
		background: #b0d1dc;
		transform: translateY(-1px);
	}
	@media (max-width: 480px) {
		.form-grid {
			grid-template-columns: 1fr;
		}
		.field {
			grid-column: span 1 !important;
		}
		.fab-btn .btn-text {
			display: none;
		}
		.fab-btn {
			padding: 1rem;
			border-radius: 50%;
		}
	}
</style>
