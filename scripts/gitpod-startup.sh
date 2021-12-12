#!/bin/bash
set -ex

# copy gitpod's gitconfig so that we can use their auto-generated credentials
sudo cp /home/gitpod/.gitconfig /etc/gitconfig

# replace the neutered 'dotfiles' clone with a real one.
sudo rm -r /home/topher/dotfiles
# sudo-ing into the 'topher' user wasn't working correctly so we do single-use commands.
sudo su -c 'git clone https://github.com/topher200/dotfiles /home/topher/dotfiles' -- topher

# re-run stow to fix symlinks
sudo su -c 'make -C /home/topher/dotfiles stow' -- topher

# startup a new tmux session as 'topher'
sudo su -c 'tmux new-sess -A -s work' -- topher
