#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"
docker build -t bun-app .
docker run --rm -p 3000:3000 bun-app
