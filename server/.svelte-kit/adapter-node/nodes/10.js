import * as server from '../entries/pages/login/_page.server.ts.js';

export const index = 10;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/login/_page.svelte.js')).default;
export { server };
export const server_id = "src/routes/login/+page.server.ts";
export const imports = ["_app/immutable/nodes/10.5960bb91.js","_app/immutable/chunks/scheduler.b4dc9e3e.js","_app/immutable/chunks/index.5bde6a80.js","_app/immutable/chunks/forms.4b347861.js","_app/immutable/chunks/parse.1a86f26e.js","_app/immutable/chunks/singletons.00a0fd32.js","_app/immutable/chunks/navigation.caa4394d.js"];
export const stylesheets = ["_app/immutable/assets/10.1b2f40e7.css"];
export const fonts = [];
