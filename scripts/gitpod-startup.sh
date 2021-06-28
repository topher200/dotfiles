#!/bin/bash
set -ex

# copy gitpod's gitconfig so that we can use their auto-generated credentials
sudo cp /home/gitpod/.gitconfig /etc/gitconfig

# log into 'topher'
sudo su - topher

# replace the neutered 'dotfiles' clone with a real one
rm -r dotfiles
git clone https://github.com/topher200/dotfiles
cd dotfiles

# re-run stow to fix symlinks
make stow

# startup is a session in tmux
tmux new-sess -A -s work
