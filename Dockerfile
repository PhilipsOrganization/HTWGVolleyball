FROM node:20-slim
WORKDIR /app

# pnpm fetch does require only lockfile
COPY pnpm-lock.yaml ./

RUN npm i -g pnpm && pnpm fetch

ADD . ./
RUN pnpm install -r --offline && cd ./server && pnpm run build && cd ../scheduler && pnpm run build


EXPOSE 3000

CMD ["node", "server/build/index.js"]