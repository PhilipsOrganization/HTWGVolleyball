import * as server from '../entries/pages/profile/_page.server.ts.js';

export const index = 12;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/profile/_page.svelte.js')).default;
export { server };
export const server_id = "src/routes/profile/+page.server.ts";
export const imports = ["_app/immutable/nodes/12.5316b45b.js","_app/immutable/chunks/scheduler.b4dc9e3e.js","_app/immutable/chunks/index.5bde6a80.js","_app/immutable/chunks/each.23082635.js","_app/immutable/chunks/index.f032adce.js"];
export const stylesheets = ["_app/immutable/assets/12.474a8b87.css"];
export const fonts = [];
