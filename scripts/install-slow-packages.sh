#!/bin/bash

set -Eeuox pipefail

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# install Linuxbrew
if ! command_exists brew; then
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
brew install \
    circleci \
    gcc \
    jesseduffield/lazygit/lazygit \
    jless \
    pre-commit \
    prettier \
    shfmt \
    thefuck \
    tmuxp \
    tldr \
    screenplaydev/tap/graphite

# this is currently broken: https://github.com/jesseduffield/lazydocker/issues/273
# brew install jesseduffield/lazydocker/lazydocker

# install node packages
sudo apt-get install -y npm
sudo npm install \
    sql-formatter