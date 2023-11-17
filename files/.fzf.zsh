# shellcheck shell=bash
# Setup fzf
# ---------
if [[ ! "$PATH" == */home/linuxbrew/.linuxbrew/opt/fzf/bin* ]]; then
	PATH="${PATH:+${PATH}:}/home/linuxbrew/.linuxbrew/opt/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/linuxbrew/.linuxbrew/opt/fzf/shell/completion.zsh" 2>/dev/null

# Key bindings
# ------------
if [[ -e "/home/linuxbrew/.linuxbrew/opt/fzf/shell/key-bindings.zsh" ]]; then
	source "/home/linuxbrew/.linuxbrew/opt/fzf/shell/key-bindings.zsh"
fi
