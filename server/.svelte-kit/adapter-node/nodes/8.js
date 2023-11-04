import * as server from '../entries/pages/courses/_page.server.ts.js';

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/courses/_page.svelte.js')).default;
export { server };
export const server_id = "src/routes/courses/+page.server.ts";
export const imports = ["_app/immutable/nodes/8.04c78e44.js","_app/immutable/chunks/scheduler.b4dc9e3e.js","_app/immutable/chunks/index.5bde6a80.js","_app/immutable/chunks/each.23082635.js","_app/immutable/chunks/date.c34f21ca.js","_app/immutable/chunks/index.f032adce.js"];
export const stylesheets = ["_app/immutable/assets/8.570e08b7.css","_app/immutable/assets/date.acf90f0a.css"];
export const fonts = [];
