#!/bin/bash

# Installs packages which are slow to install. Should be run after
# ./install-fast-packages.sh

set -Eeuox pipefail

command_exists() {
	command -v "$1" >/dev/null 2>&1
}

# install Linuxbrew
if ! command_exists brew; then
	NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# install frequently used apps first
brew install withgraphite/tap/graphite
brew install jesseduffield/lazygit/lazygit
brew install \
	pre-commit \
	prettier \
	shfmt

brew install \
	circleci \
	gcc \
	jesseduffield/lazydocker/lazydocker \
	jless \
	pre-commit \
	prettier \
	shfmt \
	thefuck \
	tmuxp \
	tldr
