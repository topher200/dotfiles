#!/bin/bash

set -Eeuox pipefail

# configure graphite
# these are JSON because we don't have a `graphite` binary yet
echo '{"trunk": "master"}' >.git/.graphite_repo_config
echo "{\"authToken\": \"$GRAPHITE_AUTH_TOKEN\", \"branchPrefix\": \"topher/\", \"submitIncludeCommitMessages\": true}" >~/.graphite_user_config

# configure docker hub
if [[ -z "${DOCKER_HUB_USERNAME:-}" ]] || [[ -z "${DOCKER_HUB_PAT:-}" ]]; then
	echo 'DOCKER_HUB_USERNAME and DOCKER_HUB_PAT not set, skipping docker login'
else
	echo 'DOCKER_HUB_USERNAME and DOCKER_HUB_PAT set, running docker login'
	echo "$DOCKER_HUB_PAT" | docker login -u "$DOCKER_HUB_USERNAME" --password-stdin
fi

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
