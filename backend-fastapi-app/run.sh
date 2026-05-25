#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"
docker build -t backend-fastapi-app .
docker run --rm -p 8000:8000 backend-fastapi-app
