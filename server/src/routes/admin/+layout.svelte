<script>
	import { page } from '$app/stores';

	const navItems = [
		{ href: '/admin', label: 'Dashboard', icon: '◉' },
		{ href: '/admin/users', label: 'Users', icon: '◎' },
		{ href: '/admin/groups', label: 'Groups', icon: '◈' },
		{ href: '/admin/templates', label: 'Templates', icon: '◇' }
	];

	/**
	 * @param {string} href
	 * @param {{url: URL}} url
	 */
	function isActive(href, { url }) {
		if (href === '/admin') {
			return url.pathname === '/admin';
		}
		return url.pathname.startsWith(href);
	}
</script>

<div class="admin-container">
	<aside class="admin-nav">
		<nav>
			{#each navItems as item}
				<a href={item.href} class:active={isActive(item.href, $page)}>
					<span class="icon">{item.icon}</span>
					<span class="label">{item.label}</span>
				</a>
			{/each}
		</nav>
	</aside>
	<div class="admin-content">
		<slot />
	</div>
</div>

<style>
	:global(html),
	:global(body) {
		height: 100%;
		overflow: hidden;
		padding-bottom: 0 !important;
	}

	.admin-container {
		display: flex;
		height: calc(100dvh - min(20dvh, 180px));
		gap: 0;
		overflow: hidden;
		box-sizing: border-box;
	}

	.admin-container * {
		box-sizing: border-box;
	}

	.admin-nav {
		width: 200px;
		background: #1a1a1a;
		border-right: 1px solid #2a2a2a;
		padding: 1.5rem 0;
		flex-shrink: 0;
		overflow-y: auto;
	}

	.admin-nav nav {
		display: flex;
		flex-direction: column;
		gap: 0.25rem;
		padding: 0 0.75rem;
	}

	.admin-nav a {
		display: flex;
		align-items: center;
		gap: 0.75rem;
		padding: 0.75rem 1rem;
		border-radius: 8px;
		color: #888;
		transition: all 0.15s ease;
		font-size: 0.9rem;
	}

	.admin-nav a:hover {
		background: #252525;
		color: #e0e0e0;
	}

	.admin-nav a.active {
		background: #9cc1cf20;
		color: #9cc1cf;
	}

	.admin-nav .icon {
		font-size: 1rem;
		width: 1.25rem;
		text-align: center;
	}

	.admin-content {
		flex: 1;
		padding: 2rem;
		max-width: 1200px;
		width: 100%;
		overflow-y: auto;
		overflow-x: hidden;
	}

	@media (max-width: 768px) {
		.admin-container {
			flex-direction: column;
			height: calc(100dvh - min(20dvh, 180px));
		}

		.admin-nav {
			width: 100%;
			height: auto;
			max-height: 30%;
			border-right: none;
			border-bottom: 1px solid #2a2a2a;
			padding: 0.75rem 0;
			overflow-y: auto;
		}

		.admin-nav nav {
			flex-direction: row;
			justify-content: center;
			gap: 0.5rem;
			padding: 0 1rem;
			flex-wrap: wrap;
		}

		.admin-nav a {
			padding: 0.5rem 0.75rem;
		}

		.admin-nav .label {
			display: none;
		}

		.admin-content {
			padding: 1rem;
			height: auto;
		}
	}
</style>
