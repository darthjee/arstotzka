#!/usr/bin/env bash
set -euo pipefail
set -x

bundle exec rspec
bundle exec rubocop
bundle exec rake verify_measurements
