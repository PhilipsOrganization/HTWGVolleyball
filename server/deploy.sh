#! /bin/bash

# exit on error
set -e

# backup the database before deploying
/root/backup.sh

cd /root/HTWGVolleyball/server/
git pull
bun install --frozen-lockfile
bun run build
bun run migrate
service app restart
