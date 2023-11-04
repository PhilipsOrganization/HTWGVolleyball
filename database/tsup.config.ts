import { defineConfig } from "tsup";

export default defineConfig({
  entry: ["src/index.ts", "src/migrations/*.js"],
  format: ["esm"], // Build for commonJS and ESmodules
  dts: true, // Generate declaration file (.d.ts)
  splitting: true,
  sourcemap: true,
  clean: true,
});