#!/bin/bash
set -Eeuox pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# check if we're running in codespace or gitpod, and call the correct shell script to bootstrap
# gitpod: GITPOD_WORKSPACE_ID
# codespace: CODESPACES
if [[ -n "${GITPOD_WORKSPACE_ID:-}" ]]; then
	echo "Running in gitpod"
	"$ROOT_DIR"/bootstrap-gitpod.sh
elif [[ -n "${CODESPACES:-}" ]]; then
	echo "Running in codespace"
	"$ROOT_DIR"/bootstrap-codespace.sh
else
	echo "Running in unknown environment"
	exit 1
fi
