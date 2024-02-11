#!/bin/bash
set -Eeuox pipefail

echo Installing fast packages at "$(date)"
make install-fast-packages || true
echo Finished installing fast packages at "$(date)"

# use our files, not codespace's
echo removing ~/.zshrc
mv ~/.zshrc ~/.zshrc.bak || true
echo removing ~/.gitconfig
mv ~/.gitconfig ~/.gitconfig.bak || true
echo removing ~/.oh-my-zsh
mv ~/.oh-my-zsh ~/.oh-my-zsh.bak || true

echo Running stow at "$(date)"
make
echo Finished stow at "$(date)"
