<script>
	export let data;
</script>

<h1>Your Courses:</h1>
<a href="/admin">Admin</a>

{#each data.courses as course}
	<p>{course.title}</p>
    <small>{course.id}</small>
    <form action="?/drop" method="post">
        <input type="hidden" name="courseId" value={course.id} />
        <button>Drop</button>
    </form>
{/each}

<h1>All Courses:</h1>
{#each data.allCourses as course}
	<p>{course.title}</p>
    <small>{course.id}</small>
	<form action="?/enlist" method="post">
		<input type="hidden" name="courseId" value={course.id} />
		<button>Enlist</button>
	</form>
{/each}
