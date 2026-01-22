<script lang="ts">
	import { styleToString } from '../utils';

	export let style: Record<string, string | number> = {};
	let className: string | undefined = undefined;
	export { className as class };

	const styleDefault = {
		fontSize: '14px',
		lineHeight: '24px',
		margin: '16px 0',
		...style
	};
</script>

<p style={styleToString(styleDefault)} {...$$restProps} class={className}>
	<slot />
</p>
