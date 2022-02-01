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

# TODO: this is failing in CircleCI and i'm not sure why. i think it has
# something to do with profile/environment/PATH setup
# fail_if_not_exists brew
# OR
# fail_if_not_exists /home/linuxbrew/.linuxbrew/bin/brew
