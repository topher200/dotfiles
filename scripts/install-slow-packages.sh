#!/bin/bash

# Installs packages which are slow to install. Should be run after
# ./install-fast-packages.sh

set -Eeuox pipefail

command_exists() {
	command -v "$1" >/dev/null 2>&1
}

sudo apt-get update && DEBIAN_FRONTEND=noninteractive sudo apt-get install -y \
	autojump \
	build-essential \
	colorized-logs \
	curl \
	docker \
	fd-find \
	file \
	flameshot \
	fzf \
	gron \
	htop \
	httpie \
	moreutils \
	neovim \
	jc \
	jello \
	jq \
	pspg \
	shellcheck \
	silversearcher-ag \
	stgit \
	tig \
	tree \
	unp \
	unzip \
	wget \
	xsel

# don't fail if some installs don't succeed
set +e
DEBIAN_FRONTEND=noninteractive sudo apt-get install -y \
	jello \
	jq || true
set -e

# TODO add back in 'git' installation

# pet snippet manager
if [ ! -f /tmp/pet.deb ]; then
	wget https://github.com/knqyf263/pet/releases/download/v0.3.6/pet_0.3.6_linux_amd64.deb -O /tmp/pet.deb
	sudo dpkg -i /tmp/pet.deb
fi

# install viddy, from https://github.com/sachaos/viddy
if [ ! -f /usr/local/bin/viddy ]; then
	wget -O /tmp/viddy.tar.gz https://github.com/sachaos/viddy/releases/download/v0.3.0/viddy_0.3.0_Linux_x86_64.tar.gz
	pushd /tmp || exit
	tar xvf /tmp/viddy.tar.gz
	sudo mv /tmp/viddy /usr/local/bin
	popd || exit
fi

# TODO: install with 'apt'
# install exa, (not available on Ubuntu 20.04)
if [ ! -f /usr/local/bin/exa ]; then
	wget -O /tmp/exa.zip https://github.com/ogham/exa/releases/download/v0.10.0/exa-linux-x86_64-v0.10.0.zip
	pushd /tmp || exit
	unp exa.zip
	sudo mv bin/exa /usr/local/bin
	popd || exit
fi

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
	shfmt

brew install \
	circleci \
	ijq \
	gcc \
	jesseduffield/lazydocker/lazydocker \
	jless \
	thefuck \
	tmuxp \
	tldr
