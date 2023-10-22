<script lang="ts">
	import { page } from '$app/stores';
	export let title = 'Error';
</script>

<section>
	<h1>{title}</h1>
	{#if $page.error}
		<p>Error: {$page.error?.message}</p>
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
		font-size: 18px;
	}
</style>
