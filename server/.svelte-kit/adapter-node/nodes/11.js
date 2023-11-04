import * as server from '../entries/pages/logout/_page.server.ts.js';

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/logout/_page.svelte.js')).default;
export { server };
export const server_id = "src/routes/logout/+page.server.ts";
export const imports = ["_app/immutable/nodes/11.c039bb0e.js","_app/immutable/chunks/scheduler.b4dc9e3e.js","_app/immutable/chunks/index.5bde6a80.js"];
export const stylesheets = [];
export const fonts = [];
