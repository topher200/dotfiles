#!/bin/bash
set -Eeuox pipefail

cd /home/gitpod/.dotfiles

echo Installing fast packages at "$(date)"
make install-fast-packages
echo Finished installing fast packages at "$(date)"

# gitpod provides garbage ~/.zshrc and .gitconfig files
echo removing ~/.zshrc
cat ~/.zshrc
rm ~/.zshrc
echo removing ~/.gitconfig
cat ~/.gitconfig
rm ~/.gitconfig

echo Running stow at "$(date)"
make
echo Finished stow at "$(date)"
