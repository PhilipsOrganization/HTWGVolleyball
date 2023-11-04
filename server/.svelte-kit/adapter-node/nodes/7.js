import * as server from '../entries/pages/admin/users/_id_/stats/_page.server.ts.js';

export const index = 7;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/admin/users/_id_/stats/_page.svelte.js')).default;
export { server };
export const server_id = "src/routes/admin/users/[id]/stats/+page.server.ts";
export const imports = ["_app/immutable/nodes/7.ee2d0faf.js","_app/immutable/chunks/scheduler.b4dc9e3e.js","_app/immutable/chunks/index.5bde6a80.js","_app/immutable/chunks/each.23082635.js","_app/immutable/chunks/index.f032adce.js"];
export const stylesheets = ["_app/immutable/assets/7.ce8f3964.css"];
export const fonts = [];
