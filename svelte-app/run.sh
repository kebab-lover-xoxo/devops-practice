#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"
docker build -t svelte-app .
docker run --rm -p 4173:4173 svelte-app
