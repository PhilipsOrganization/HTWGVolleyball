

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.06e6088b.js","_app/immutable/chunks/scheduler.b4dc9e3e.js","_app/immutable/chunks/index.5bde6a80.js","_app/immutable/chunks/stores.b0e0761f.js","_app/immutable/chunks/singletons.00a0fd32.js"];
export const stylesheets = [];
export const fonts = [];
