#!/bin/bash
set -eo pipefail
shopt -s nullglob

source /usr/local/bin/secret-helper.sh

export_secret_from_env "RESTIC_REPOSITORY"
export_secret_from_env "RESTIC_PASSWORD"
export_secret_from_env "RESTIC_KEY_HINT"

exec "$@"