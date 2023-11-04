

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/login/_error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.faa90e6d.js","_app/immutable/chunks/scheduler.b4dc9e3e.js","_app/immutable/chunks/index.5bde6a80.js","_app/immutable/chunks/error-page.bc1f8af9.js","_app/immutable/chunks/stores.b0e0761f.js","_app/immutable/chunks/singletons.00a0fd32.js"];
export const stylesheets = ["_app/immutable/assets/2.9874f97d.css","_app/immutable/assets/error-page.cf3b55aa.css"];
export const fonts = [];
