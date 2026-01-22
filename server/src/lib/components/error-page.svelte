<script>
	import { page } from '$app/state';

	let { title = 'Error', children } = $props();
</script>

<section>
	<h1>{title}</h1>
	{#if page.error}
		<p>Error: {page.error.message}</p>
	{/if}
	{#if children}
		{@render children()}
	{/if}
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
