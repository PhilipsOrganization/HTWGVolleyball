FROM node:20-slim AS base
WORKDIR /app

# pnpm fetch does require only lockfile
COPY pnpm-lock.yaml ./

RUN npm i -g pnpm && pnpm fetch

ADD . ./
RUN pnpm install -r --offline && pnpm run build

EXPOSE 3000

CMD [ "node", "-r", "dotenv/config", "build" ]