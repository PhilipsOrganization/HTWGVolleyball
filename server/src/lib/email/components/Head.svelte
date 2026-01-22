<script lang="ts">
	import type { HTMLAttributes } from 'svelte/elements';
	interface $$Props extends HTMLAttributes<HTMLHeadElement> {}
</script>

<head {...$$restProps}>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
	<slot />
</head>
