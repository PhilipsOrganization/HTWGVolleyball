<script>
	export let data;
</script>

<h1>List of Posts ({data.posts.length})</h1>

{#each data.posts as post}
	<h2>{post.title}</h2>
{/each}

<form method="POST">
	<label for="title">Title</label>
	<input type="text" name="title" placeholder="Post Title" />
	<br />
	<textarea name="body" placeholder="Post Content" />
	<br />
	<input type="submit" value="New Post" />
</form>
