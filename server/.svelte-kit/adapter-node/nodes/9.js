import * as server from '../entries/pages/courses/_id_/_page.server.ts.js';

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/courses/_id_/_page.svelte.js')).default;
export { server };
export const server_id = "src/routes/courses/[id]/+page.server.ts";
export const imports = ["_app/immutable/nodes/9.09551b70.js","_app/immutable/chunks/scheduler.b4dc9e3e.js","_app/immutable/chunks/index.5bde6a80.js","_app/immutable/chunks/each.23082635.js","_app/immutable/chunks/forms.4b347861.js","_app/immutable/chunks/parse.1a86f26e.js","_app/immutable/chunks/singletons.00a0fd32.js","_app/immutable/chunks/navigation.caa4394d.js","_app/immutable/chunks/stores.b0e0761f.js"];
export const stylesheets = ["_app/immutable/assets/9.039ca680.css"];
export const fonts = [];
