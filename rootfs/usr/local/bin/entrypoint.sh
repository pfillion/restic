#!/bin/bash
set -eo pipefail
shopt -s nullglob

source /usr/local/bin/secret-helper.sh

export_secret_from_env "RESTIC_KEY_HINT"

exec "$@"