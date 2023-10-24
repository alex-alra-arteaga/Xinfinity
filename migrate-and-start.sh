#!/bin/bash

npx prisma generate
# npx prisma generate --schema=./path/to/schema.prisma
npx prisma db push
node server.js