import * as server from '../entries/pages/admin/users/_page.server.ts.js';

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/admin/users/_page.svelte.js')).default;
export { server };
export const server_id = "src/routes/admin/users/+page.server.ts";
export const imports = ["_app/immutable/nodes/6.3d2b2522.js","_app/immutable/chunks/scheduler.b4dc9e3e.js","_app/immutable/chunks/index.5bde6a80.js","_app/immutable/chunks/each.23082635.js"];
export const stylesheets = ["_app/immutable/assets/6.73bd943d.css"];
export const fonts = [];
