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

fail_if_not_exists brew
fail_if_not_exists circleci
fail_if_not_exists gcc
fail_if_not_exists lazygit
fail_if_not_exists gg
fail_if_not_exists jless
fail_if_not_exists pre-commit
fail_if_not_exists prettier
fail_if_not_exists shfmt
fail_if_not_exists thefuck
fail_if_not_exists tmuxp
fail_if_not_exists tldr
fail_if_not_exists graphite
fail_if_not_exists gt
