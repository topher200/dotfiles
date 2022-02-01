#!/bin/bash

set -Eeuox pipefail

exists() {
    command -v "$1" >/dev/null 2>&1
}

fail_if_not_exists() {
    if ! exists "$1"; then
        echo "$1" not found
        exit 1
    fi
}

fail_if_not_exists lazygit

# our test environment might not add brew to our path
fail_if_not_exists /home/linuxbrew/.linuxbrew/bin/brew
