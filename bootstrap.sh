#!/bin/bash
set -ex

make install-fast-packages

# gitpod provides garbage ~/.zshrc and .gitconfig files
echo removing ~/.zshrc
cat ~/.zshrc
rm ~/.zshrc
echo removing ~/.gitconfig
cat ~/.gitconfig
rm ~/.gitconfig

make
