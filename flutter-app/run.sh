#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"
docker build -t flutter-app .
docker run --rm -p 80:80 flutter-app
