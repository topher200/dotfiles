#!/bin/bash
set -Eeuox pipefail

cd /home/gitpod/.dotfiles

make install-fast-packages

# gitpod provides garbage ~/.zshrc and .gitconfig files
echo removing ~/.zshrc
cat ~/.zshrc
rm ~/.zshrc
echo removing ~/.gitconfig
cat ~/.gitconfig
rm ~/.gitconfig

make
