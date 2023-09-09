<script>
	import Course from '$lib/components/course.svelte';

	export let data;
</script>

<a href="/admin">Admin</a>

<h1>Your Courses:</h1>
{#each data.courses as course}
	<Course {course} action="?/drop" actionName="drop" />
{/each}

<h1>All Courses:</h1>
{#each data.allCourses as course}
	{#if course.isEnrolled}
		<Course {course} />
	{:else}
		<Course {course} action="?/enlist" actionName="enlist" />
	{/if}
{/each}
