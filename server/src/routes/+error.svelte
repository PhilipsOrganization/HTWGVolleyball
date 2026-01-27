<script>
	import { page } from '$app/state';
	import ErrorPage from '$lib/components/error-page.svelte';
</script>

<ErrorPage title={page.error?.message ?? 'An Error Occurred :('}>
	{#snippet children()}
		<a href="/">Go back</a>
	{/snippet}
</ErrorPage>

<style>
	a {
		font-size: 18px;
		font-weight: bold;
		color: var(--cAccent);
	}
</style>
