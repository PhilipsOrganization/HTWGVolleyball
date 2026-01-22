<script lang="ts">
	import { styleToString } from '../utils';

	export let style: Record<string, string | number> = {};
	let className: string | undefined = undefined;
	export { className as class };

	const styleDefault = {
		display: 'inline-flex',
		justifyContent: 'center',
		alignItems: 'center',
		...style
	};
</script>

<td style={styleToString(styleDefault)} role="presentation" {...$$restProps} class={className}>
	<slot />
</td>
