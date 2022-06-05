#!/bin/bash
set -ex

make install-fast-packages

# gitpod provides a garbage ~/.zshrc file
echo removing ~/.zshrc
cat ~/.zshrc
rm ~/.zshrc

# gitpod stores git credentials in .gitconfig. we need those! save them and add
# them back in later
mv ~/.gitconfig ~/.gitconfig.gitpod

make

echo concatenating  ~/.gitconfig together
cat ~/.gitconfig.gitpod >> ~/.gitconfig