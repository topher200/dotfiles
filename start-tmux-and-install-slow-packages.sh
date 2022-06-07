#!/bin/bash

# configure graphite
echo '{"trunk": "master"}' > .git/.graphite_repo_config

# start tmux session, with background windows doing setup
tmux new-session -d -s work
tmux new-window -n install-slow 'cd ~/.dotfiles && make install-slow-packages'
tmux select-window -t 1

# connect to tmux session
tmux attach-session -d -t work
