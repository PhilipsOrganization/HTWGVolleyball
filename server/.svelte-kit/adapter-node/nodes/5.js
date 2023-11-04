import * as server from '../entries/pages/admin/_page.server.ts.js';

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/admin/_page.svelte.js')).default;
export { server };
export const server_id = "src/routes/admin/+page.server.ts";
export const imports = ["_app/immutable/nodes/5.4571109c.js","_app/immutable/chunks/scheduler.b4dc9e3e.js","_app/immutable/chunks/index.5bde6a80.js","_app/immutable/chunks/each.23082635.js","_app/immutable/chunks/navigation.caa4394d.js","_app/immutable/chunks/singletons.00a0fd32.js","_app/immutable/chunks/stores.b0e0761f.js","_app/immutable/chunks/date.c34f21ca.js","_app/immutable/chunks/index.f032adce.js"];
export const stylesheets = ["_app/immutable/assets/5.3cc5233a.css","_app/immutable/assets/date.acf90f0a.css"];
export const fonts = [];
