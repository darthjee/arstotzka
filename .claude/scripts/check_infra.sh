#!/usr/bin/env bash
set -euo pipefail
set -x

docker-compose config --quiet
docker-compose build base_build
