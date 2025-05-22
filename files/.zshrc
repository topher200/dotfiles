#!/bin/zsh
# shellcheck shell=bash

export PATH=$HOME/bin:$HOME/go/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export ZSH=~/.oh-my-zsh
# shellcheck disable=SC2034
HYPHEN_INSENSITIVE="true"
zstyle ':omz:update' mode reminder
# if we want to switch to 'off':
# zstyle ':omz:update' mode disabled
# shellcheck disable=SC2034
DISABLE_AUTO_TITLE="true"
# shellcheck disable=SC2034
DISABLE_UNTRACKED_FILES_DIRTY="true"
# shellcheck disable=SC2034
HIST_STAMPS="yyyy-mm-dd"
ZSH_CUSTOM=~/zsh-custom
# https://github.com/ohmyzsh/ohmyzsh/issues/449
setopt NO_NOMATCH
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# shellcheck disable=SC2034
plugins=(
	autojump
	github
	httpie
	safe-paste
	zsh-vi-mode
)
# Disable oh-my-zsh's theme so 'pure' can run it instead.
# We must nullify ZSH_THEME, then source oh-my-zsh, then source pure.
# https://github.com/sindresorhus/pure?tab=readme-ov-file#oh-my-zsh
export ZSH_THEME=""
# Disable oh-my-zsh update reminders (we have a script)
zstyle ':omz:update' mode disabled
# shellcheck source=.oh-my-zsh/oh-my-zsh.sh
source $ZSH/oh-my-zsh.sh

# enable 'kitty' terminal emulator
if command -v kitty >/dev/null; then
	autoload -Uz compinit
	compinit
	kitty + complete setup zsh | source /dev/stdin
fi

# shellcheck disable=SC1090
source $ZSH_CUSTOM/zsh-async/async.zsh
# shellcheck disable=SC1090
source $ZSH_CUSTOM/invoke-completion.sh

# make sure our locale can handle unicode chars in prompt
export LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

# clean up extra spaces in history commands
setopt hist_reduce_blanks
unsetopt hist_ignore_space

# don't autojump into directories
unsetopt autocd

# just run commands with '!!' (like 'sudo !!'), don't try to verify
setopt no_histverify

# auto complete suggestions
# shellcheck disable=SC1090
source $ZSH_CUSTOM/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=bold,underline"
export ZSH_AUTOSUGGEST_USE_ASYNC=true
# shellcheck disable=SC1090
source $ZSH_CUSTOM/zsh-autosuggestions/zsh-autosuggestions.zsh
# speed up pasting. https://github.com/zsh-users/zsh-autosuggestions/issues/141
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=5

# tmuxinator auto completions
# shellcheck disable=SC1090
source $ZSH_CUSTOM/tmuxinator.zsh

# add 'pure-prompt'
fpath+=("$ZSH_CUSTOM/pure")
autoload -U promptinit
promptinit
# shellcheck disable=SC2034
PURE_CMD_MAX_EXEC_TIME=1
# shellcheck disable=SC2034
PURE_PROMPT_SYMBOL=$
# shellcheck disable=SC2034
PURE_PROMPT_VICMD_SYMBOL=$
# shellcheck disable=SC2034
PURE_GIT_UNTRACKED_DIRTY=0
zstyle :prompt:pure:virtualenv color green
zstyle :prompt:pure:git:stash show yes
prompt pure

### pet (command line snippet manager)
# save previous command to pet
function petme() {
	PREV=$(fc -lrn | head -n 1)
	sh -c "pet new $(printf %q "$PREV")"
}
# search pets
function pet-select() {
	# shellcheck disable=SC2153,SC2034
	BUFFER=$(pet search --color --query "$LBUFFER")
	# shellcheck disable=SC2034
	CURSOR=$#BUFFER
	zle redisplay
}
zle -N pet-select
stty -ixon
# this bindkey must be executed after zvm, see zvm_after_init
# bindkey '^s' pet-select
### end pet (command line snippet manager)

# https://direnv.net/docs/hook.html
eval "$(direnv hook zsh)"

setopt globdots

export EDITOR=nvim
export VISUAL=nvim

# Experimental hack: let's add work's node to our PATH for Vim Copilot
export PATH="/home/topher/micromamba/envs/memfault/.volta/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
# shellcheck disable=SC1090
if [ -f "$HOME/Downloads/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/Downloads/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
# shellcheck disable=SC1090
if [ -f "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc"; fi

# include my non-shell-specific code
# shellcheck source=topherrc
source "$HOME"/topherrc
# shellcheck source=graphiterc
source "$HOME"/graphiterc
# shellcheck source=fzfrc
source "$HOME"/fzfrc
if [[ -f "$HOME"/Downloads/secretsrc ]]; then
	# shellcheck disable=SC1090
	source "$HOME"/Downloads/secretsrc
fi
if [[ -f "$HOME"/Sync/secretsrc ]]; then
	# shellcheck disable=SC1090
	source "$HOME"/Sync/secretsrc
fi
if [[ -f "$HOME"/Sync/memfaultrc ]]; then
	# shellcheck disable=SC1090
	source "$HOME"/Sync/memfaultrc
fi
if [[ -f "$HOME"/systemrc ]]; then
	# shellcheck disable=SC1090
	source "$HOME"/systemrc
fi

alias cam='micromamba activate memfault'

# Shell-GPT integration ZSH v0.2
_sgpt_zsh() {
	if [[ -n "$BUFFER" ]]; then
		_sgpt_prev_cmd=$BUFFER
		BUFFER+="⌛"
		zle -I && zle redisplay
		BUFFER=$(sgpt --shell --no-interaction <<<"$_sgpt_prev_cmd")
		zle end-of-line
	fi
}
zle -N _sgpt_zsh
bindkey ^l _sgpt_zsh
# Shell-GPT integration ZSH v0.2

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba init' !!
export MAMBA_EXE='/home/topher/.local/bin/micromamba'
export MAMBA_ROOT_PREFIX='/home/topher/micromamba'
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2>/dev/null)"
if "$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" >/dev/null 2>&1; then
	eval "$__mamba_setup"
else
	alias micromamba='$MAMBA_EXE' # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<
