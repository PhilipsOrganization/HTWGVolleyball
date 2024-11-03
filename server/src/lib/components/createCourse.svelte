<script>
	import { page } from '$app/stores';
	import { addDays, nextMonday, nextSaturday, nextThursday, nextWednesday, setHours, setMinutes } from 'date-fns';

	const difficulties = ['Beginner', 'Advanced', 'Actives', 'Beach Course', 'Actives - 5:1 System', 'Free Game', 'Christmas Special🎄'];

	$: form = $page.form;

	let name = 'Beginner';

	/**
	 * @type {HTMLDialogElement}
	 */
	let dialogEl;

	/**
	 * @type {any[]}
	 */
	let courses = [];
	reset();

	function reset() {
		courses = [
			{
				name: difficulties[0],
				settings: {
					name: difficulties[0],
					location: 'Ellenrieder Sporthalle',
					maxParticipants: 18,
					time: '17:30',
					duration: 1.5,
					date: nextMonday(new Date()),
					publishOn: setTo12(nextThursday(new Date()))
				}
			},
			{
				name: difficulties[1],
				settings: {
					name: difficulties[1],
					location: 'Ellenrieder Sporthalle',
					maxParticipants: 18,
					time: '19:00',
					duration: 1.5,
					date: nextMonday(new Date()),
					publishOn: setTo12(nextThursday(new Date()))
				}
			},
			{
				name: difficulties[2],
				settings: {
					name: difficulties[2],
					location: 'Ellenrieder Sporthalle',
					maxParticipants: 18,
					time: '20:30',
					duration: 1.5,
					date: nextMonday(new Date()),
					publishOn: setTo12(nextThursday(new Date()))
				}
			},
			{
				name: difficulties[4],
				settings: {
					name: difficulties[4],
					location: 'Ellenrieder Sporthalle',
					maxParticipants: 18,
					time: '20:30',
					duration: 1.5,
					date: nextWednesday(new Date()),
					publishOn: setTo12(nextThursday(new Date()))
				}
			},
			{
				name: difficulties[5],
				settings: {
					name: difficulties[5],
					location: 'Petershausener Sporthalle',
					maxParticipants: 36,
					time: '12:00',
					duration: 1.5,
					date: nextSaturday(addDays(new Date(), 7)),
					publishOn: setTo12(nextThursday(new Date()))
				}
			}
		];
	}
	$: defaults = courses.find((c) => c.name === name)?.settings;

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

	/**
	 * @param {Date} date
	 */
	function setTo12(date) {
		return setMinutes(setHours(date, 12), 0);
	}
</script>

<button class="highlight" id="open" on:click={() => dialogEl.showModal()}>Create Course</button>
<dialog bind:this={dialogEl}>
	<h1>New Course</h1>
	<form method="POST" action="?/create-course">
		<button id="close" value="cancel" formmethod="dialog">x</button>
		<field>
			<label for="name">Name</label>
			<select bind:value={name} name="name">
				{#each difficulties as difficulty}
					<option value={difficulty}>{difficulty}</option>
				{/each}
			</select>
			<small class="error">{form?.name ?? ''}</small>
		</field>

		<field>
			<label for="location">Location</label>
			<input value={defaults?.location ?? ''} type="text" name="location" placeholder="Location" />
			<small class="error">{form?.location ?? ''}</small>
		</field>

		<field>
			<label for="date">Date</label>
			<input value={dateTimeToDateString(defaults?.date)} type="date" name="date" placeholder="Date" />
			<small class="error">{form?.date ?? ''}</small>
		</field>

		<field>
			<label for="time">Time</label>
			<input value={defaults?.time ?? ''} type="time" name="time" placeholder="Time" />
			<small class="error">{form?.time ?? ''}</small>
		</field>

		<field>
			<label for="maxParticipants">Max Participants</label>
			<input value={defaults?.maxParticipants ?? ''} type="number" name="maxParticipants" placeholder="Max Participants" />
			<small class="error">{form?.maxParticipants ?? ''}</small>
		</field>

		<field>
			<label for="publishOn">Publish On</label>
			<input value={dateTimeToString(defaults?.publishOn)} type="datetime-local" name="publishOn" placeholder="Publish On" />
			<small class="error">{form?.publishOn ?? ''}</small>
		</field>

		<field>
			<label class="center">
				Allow Users to Book Multiple Courses
				<input type="checkbox" name="allowDoubleBookings" switch />
			</label>
		</field>

		<button id="submit">Submit</button>
	</form>
</dialog>

<style>
	dialog {
		position: relative;
		padding: 12px 3em 30px;
		width: min(90vw, 400px);
		max-width: calc(100vw - 9em);
		background: #383838;
		color: rgb(182, 182, 182);
		border-radius: 8px;
	}

	h1 {
		color: #e0e0e0;
	}

	#open {
		position: fixed;
		bottom: 1em;
		right: 1em;
		z-index: 100;
		padding: 0.5em 1em;
		background: #9cc1cf;
		color: #000;
	}

	#close {
		position: absolute;
		inset: 10px 10px auto auto;
		padding: 0.5em 0.75em;
		background: rgb(19, 19, 19);
		border: none;
		border-radius: 50%;
		font-size: 1.5em;
		line-height: 1;
		cursor: pointer;
	}

	#submit {
		min-width: 60%;
	}

	form {
		display: flex;
		flex-direction: column;
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
</style>
