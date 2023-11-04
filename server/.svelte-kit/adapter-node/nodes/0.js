

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.dee7b630.js","_app/immutable/chunks/scheduler.b4dc9e3e.js","_app/immutable/chunks/index.5bde6a80.js","_app/immutable/chunks/navigation.caa4394d.js","_app/immutable/chunks/singletons.00a0fd32.js","_app/immutable/chunks/stores.b0e0761f.js"];
export const stylesheets = ["_app/immutable/assets/0.b780956e.css"];
export const fonts = [];
