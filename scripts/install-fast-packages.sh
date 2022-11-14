#!/bin/bash

set -Eeuox pipefail

# timezone copy and DEBIAN_FRONTEND are to stop 'tzdata' from prompting for timezone during install
sudo ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
sudo apt update --yes
DEBIAN_FRONTEND=noninteractive sudo apt install -y \
	autojump \
	build-essential \
	colorized-logs \
	curl \
	direnv \
	docker \
	fd-find \
	file \
	flameshot \
	fzf \
	htop \
	httpie \
	moreutils \
	neovim \
	jq \
	pspg \
	shellcheck \
	silversearcher-ag \
	stow \
	tig \
	tmux \
	tree \
	unp \
	unzip \
	vim \
	wget \
	xsel \
	zsh

# TODO add back in 'git' installation

# TODO: use this for more checks
command_exists() {
	command -v "$1" >/dev/null 2>&1
}

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

# set shell to zsh
sudo chsh -s "$(command -v zsh)" "$(whoami)"
