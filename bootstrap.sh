#!/bin/bash
set -Eeuox pipefail

# if we're running in gitpod, cd to the gitpod checkout location
if [[ -d "/home/gitpod/.dotfiles" ]]; then
	cd /home/gitpod/.dotfiles
fi

echo Installing fast packages at "$(date)"
make install-fast-packages
echo Finished installing fast packages at "$(date)"

# gitpod stores git credentials in .gitconfig. we need those! save them and add
# them back in later. same for .zshrc settings
mv ~/.gitconfig ~/.gitconfig.gitpod
mv ~/.zshrc ~/.zshrc.gitpod

echo Running stow at "$(date)"
make
echo Finished stow at "$(date)"

echo concatenating ~/.gitconfig together
cat ~/.gitconfig.gitpod >> ~/.gitconfig
echo concatenating ~/.zshrc together
cat ~/.zshrc.gitpod >> ~/.zshrc
