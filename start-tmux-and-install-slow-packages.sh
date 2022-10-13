#!/bin/bash

set -Eeuox pipefail

# configure graphite
gt auth --token "$GRAPHITE_AUTH_TOKEN"
gt user submit-body --include-commit-messages
gt user branch-prefix --set topher/
# this command takes effect in the current repo
gt repo init --no-interactive --trunk master

# start tmux session, with background windows doing setup
tmux new-session -d -s work
if [[ -d /workspace/dotfiles ]]; then
	echo 'running in /workspace/dotfiles'
	tmux new-window -n install-slow 'cd /workspace/dotfiles && make install-slow-packages && pre-commit install --install-hooks'
else
	# if we're not already in a dotfiles repo, find one
	echo 'running in ~/.dotfiles'
	tmux new-window -n install-slow 'cd ~/.dotfiles && make install-slow-packages && pre-commit install --install-hooks'
fi
tmux select-window -t 1

# connect to tmux session
tmux attach-session -d -t work
