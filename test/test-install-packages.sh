#!/bin/bash

# verbose
set -x
set -euo pipefail

exists() {
    command -v "$1" >/dev/null 2>&1
}

fail_if_not_exists() {
    if ! exists "$1"; then
        echo "$1" not found
    fi
}

fail_if_not_exists stg
