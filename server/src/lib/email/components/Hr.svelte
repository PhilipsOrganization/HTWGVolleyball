<script lang="ts">
	import { styleToString } from '../utils';

	export let style: Record<string, string | number> = {};
	let className: string | undefined = undefined;
	export { className as class };

	const styleDefault = {
		width: '100%',
		border: 'none',
		borderTop: '1px solid #eaeaea',
		...style
	};
</script>

<hr style={styleToString(styleDefault)} {...$$restProps} class={className} />
