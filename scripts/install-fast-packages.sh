#!/bin/bash

set -Eeuox pipefail

# timezone copy and DEBIAN_FRONTEND are to stop 'tzdata' from prompting for timezone during install
sudo ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
# workaround for heroku error in apt-get. Remove this when CI passes without it
# (ie gitpod apt-get works without error).
sudo rm -rf /etc/apt/sources.list.d/heroku.list
sudo apt-get update --yes
DEBIAN_FRONTEND=noninteractive sudo apt install -y \
	direnv \
	stow \
	tmux \
	zsh

# set shell to zsh
sudo chsh -s "$(command -v zsh)" "$(whoami)"
