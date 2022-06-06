#!/bin/bash

tmux new-session -d -s work
tmux new-window -n install-slow 'cd ~/.dotfiles && make install-slow-packages'
tmux select-window -t 1
tmux attach-session -d -t work
