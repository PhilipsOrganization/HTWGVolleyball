<script lang="ts">
	import ErrorPage from '$lib/components/error-page.svelte';
	import { page } from '$app/stores';

	const error = $page.error;
</script>

<ErrorPage title="An Error Occurred :(">
	<a href="/">Go back</a>
</ErrorPage>

<style>
	a {
		font-size: 18px;
		font-weight: bold;
		color: var(--cAccent);
	}
</style>
