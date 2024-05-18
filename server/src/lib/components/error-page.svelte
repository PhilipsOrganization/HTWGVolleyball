<script lang="ts">
	import { dev } from '$app/environment';
	import { page } from '$app/stores';

	export let title = 'Error';

	const error = $page.error;
	const stack = dev && error ? error.stack : '';
</script>

<section>
	<h1>{title}</h1>
	{#if error}
		<p>Error: {error.message}</p>
		{#if dev}
			<p>{stack}</p>
		{/if}
	{/if}
	<slot />
</section>

<style>
	section {
		padding: 20px;
		display: flex;
		flex-direction: column;
		align-items: center;
	}

	h1 {
		margin: -10px -20px 20px -20px;
		width: 100%;
		text-align: center;
		padding-bottom: 10px;
	}

	p {
		display: flex;
		font-size: 18px;
		max-width: 90%;
	}
</style>
