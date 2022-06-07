#!/bin/bash

# configure graphite
echo '{"trunk": "master"}' >.git/.graphite_repo_config
echo "{\"authToken\": \"$GRAPHITE_AUTH_TOKEN\"}" >~/.graphite_user_config

# start tmux session, with background windows doing setup
tmux new-session -d -s work
if [[ -d /workspace/dotfiles ]]; then
    tmux new-window -n install-slow 'cd /workspace/dotfiles && make install-slow-packages && pre-commit install --install-hooks'
else
    # if we're not already in a dotfiles repo, find one
    tmux new-window -n install-slow 'cd ~/.dotfiles && make install-slow-packages && pre-commit install --install-hooks'
fi
tmux select-window -t 1

# connect to tmux session
tmux attach-session -d -t work
