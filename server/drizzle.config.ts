import { defineConfig } from 'drizzle-kit';
import dotenv from 'dotenv';

dotenv.config({ path: ".env.local" });

const env = process.env;
if (!env.POSTGRES_CONNECTION_STRING) {
    throw new Error("POSTGRES_CONNECTION_STRING is not defined");
}


export default defineConfig({
    schema: "./src/lib/db/*",
    out: "./drizzle",
    dialect: "postgresql",
    dbCredentials: {
        url: env.POSTGRES_CONNECTION_STRING,
        ssl: false,
    },
    introspect: {
        casing: "camel"
    }
});