<script>
	export let data;
</script>

<form method="POST" action="?/create-course">
	<label for="title">Title</label>
	<input type="text" name="title" placeholder="Post Title" />
	<br />
	<textarea name="body" placeholder="Post Content" />
	<br />
	<button>Submit</button>
</form>

<h1>Courses</h1>
{#each data.courses as course}
	<p>{course.title}</p>
	<small>{course.id}</small>
	<form action="?/delete-course" method="post">
		<input type="hidden" name="courseId" value={course.id} />
		<button>delete</button>
	</form>
{/each}


<h1>Users</h1>
{#each data.users as user}
	<p>{user.username}</p>
	<small>{user.id}</small>
	<b>{user.role}</b>
	<form action="?/delete-user" method="post">
		<input type="hidden" name="userId" value={user.id} />
		<button>promote to admin</button>
		<button>delete</button>
	</form>
{/each}