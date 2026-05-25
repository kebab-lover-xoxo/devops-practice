#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"
docker build -t backend-express-app .
docker run --rm -p 4000:4000 backend-express-app
