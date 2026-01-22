<script lang="ts">
	import { styleToString } from '../utils';

	export let style: Record<string, string | number> = {};
	let className: string | undefined = undefined;
	export { className as class };
	export let target = '_blank';
	export let href = '';

	const styleDefault = {
		color: '#067df7',
		textDecoration: 'none',
		...style
	};
</script>

<a {...$$restProps} {href} {target} style={styleToString(styleDefault)} class={className}>
	<slot />
</a>
