import * as server from '../entries/pages/register/_page.server.ts.js';

export const index = 13;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/register/_page.svelte.js')).default;
export { server };
export const server_id = "src/routes/register/+page.server.ts";
export const imports = ["_app/immutable/nodes/13.ccd039b9.js","_app/immutable/chunks/scheduler.b4dc9e3e.js","_app/immutable/chunks/index.5bde6a80.js","_app/immutable/chunks/forms.4b347861.js","_app/immutable/chunks/parse.1a86f26e.js","_app/immutable/chunks/singletons.00a0fd32.js","_app/immutable/chunks/navigation.caa4394d.js"];
export const stylesheets = ["_app/immutable/assets/13.03da2e56.css"];
export const fonts = [];
