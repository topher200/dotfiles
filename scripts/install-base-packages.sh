#!/bin/bash

set -Eeuox pipefail

# install Linuxbrew
if ! command_exists brew; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
