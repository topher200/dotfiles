#!/bin/bash
set -Eeuox pipefail

# if we're running in gitpod, cd to the gitpod checkout location
if [[ -d "/home/gitpod/.dotfiles" ]]; then
    cd /home/gitpod/.dotfiles
fi

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
