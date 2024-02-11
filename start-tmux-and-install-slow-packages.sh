#!/bin/bash

set -Eeuox pipefail

# configure graphite
# these are JSON because we don't have a `graphite` binary yet
echo '{"trunk": "master"}' >.git/.graphite_repo_config
if [[ -z "${GRAPHITE_AUTH_TOKEN:-}" ]]; then
	echo 'GRAPHITE_AUTH_TOKEN not set, skipping graphite config'
else
	echo 'GRAPHITE_AUTH_TOKEN set, configuring graphite'
	echo "{\"authToken\": \"$GRAPHITE_AUTH_TOKEN\", \"branchPrefix\": \"topher/\", \"submitIncludeCommitMessages\": true}" >~/.graphite_user_config
fi

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
	DOTFILES_REPO=/workspace/dotfiles
elif [[ -d /workspaces/.codespaces/.persistedshare/dotfiles ]]; then
	DOTFILES_REPO=/workspaces/.codespaces/.persistedshare/dotfiles
	echo 'running in /workspaces/.codespaces/.persistedshare/dotfiles'
else
	echo 'running in ~/.dotfiles'
	DOTFILES_REPO=~/.dotfiles
fi
tmux new-window -n install-slow "cd $DOTFILES_REPO && make install-slow-packages && pre-commit install --install-hooks"
tmux select-window -t 1

# connect to tmux session
tmux attach-session -d -t work
