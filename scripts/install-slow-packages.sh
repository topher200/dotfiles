#!/bin/bash

# Installs packages which are slow to install. Should be run after
# ./install-fast-packages.sh

set -Eeuox pipefail

command_exists() {
	command -v "$1" >/dev/null 2>&1
}

sudo apt-get update && DEBIAN_FRONTEND=noninteractive sudo apt-get install -y \
	autojump \
	btop \
	build-essential \
	colorized-logs \
	curl \
	fd-find \
	file \
	flameshot \
	gh \
	git \
	gron \
	htop \
	httpie \
	kitty-terminfo \
	moreutils \
	neovim \
	jq \
	pspg \
	shellcheck \
	silversearcher-ag \
	stgit \
	syncthing \
	tig \
	tree \
	unp \
	unzip \
	wget \
	wmdocker \
	xclip \
	xsel

# These aren't available until super-modern Ubuntu. Don't fail if these
# installs don't succeed.
set +e
DEBIAN_FRONTEND=noninteractive sudo apt-get install -y \
	jello \
	jq || true
set -e

# install Linuxbrew
install_brew() {
	if ! command_exists brew; then
		NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
	fi
}

# if we have npm, that's a much faster installer for graphite
if ! command_exists graphite; then
	if command_exists npm; then
		npm install -g @withgraphite/graphite-cli
	else
		install_brew
		brew install withgraphite/tap/graphite
	fi
fi

# install frequently used apps first
install_brew
brew install jesseduffield/lazygit/lazygit
brew install \
	pre-commit \
	prettier \
	shfmt \
	fzf # debian as of April 2024: 0.42.0. can switch back to apt version once it's at least 0.48.1

brew install \
	atuin \
	circleci \
	ijq \
	gcc \
	jesseduffield/lazydocker/lazydocker \
	jless \
	knqyf263/pet/pet \
	tmuxp \
	tldr \
	viddy
