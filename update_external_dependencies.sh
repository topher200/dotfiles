#!/bin/bash

set -e

echo 'upgrading oh-my-zsh'
rm -r files/.oh-my-zsh
git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh files/.oh-my-zsh
rm -rf files/.oh-my-zsh/.git
echo 'done upgrading oh-my-zsh'

echo 'upgrading zsh-async'
rm -r files/zsh-custom/zsh-async
git clone --depth 1 https://github.com/mafredri/zsh-async files/zsh-custom/zsh-async
rm -rf files/zsh-custom/zsh-async/.git
echo 'done upgrading zsh-async'

echo 'upgrading zsh-autosuggestions'
rm -r files/zsh-custom/zsh-autosuggestions
git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions files/zsh-custom/zsh-autosuggestions
rm -rf files/zsh-custom/zsh-autosuggestions/.git
echo 'done upgrading zsh-autosuggestions'

echo 'upgrading zsh-syntax-highlighting'
rm -r files/zsh-custom/zsh-syntax-highlighting
git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting files/zsh-custom/zsh-syntax-highlighting
rm -rf files/zsh-custom/zsh-syntax-highlighting/.git
echo 'done upgrading zsh-syntax-highlighting'