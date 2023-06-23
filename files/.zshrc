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
	poetry
	safe-paste
	zsh-vi-mode
)
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

# make fzf use ag instead of its default (find)
export FZF_COMPLETION_TRIGGER='fzf'
export FZF_COMPLETION_OPTS='--border --info=inline'
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
export FZF_CTRL_T_COMMAND='ag --hidden --ignore .git -g ""'
# use fzf-tmux
export FZF_TMUX_OPTS='-d 30%'
# add fzf keybindings
# using lazy method described for https://github.com/jeffreytse/zsh-vi-mode
function zvm_after_init() {
	# shellcheck disable=SC1090
	[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
	[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
	[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh

	# enable pet-select (from earlier)
	bindkey '^s' pet-select

	# enable atuin for shell history, using fzf fuzzy finding
	# script from https://news.ycombinator.com/item?id=35256206
	atuin-setup() {
		if ! which atuin &>/dev/null; then return 1; fi
		bindkey '^E' _atuin_search_widget

		export ATUIN_NOBIND="true"
		eval "$(atuin init zsh)"
		fzf-atuin-history-widget() {
			setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2>/dev/null

			# local atuin_opts="--cmd-only --limit ${ATUIN_LIMIT:-5000}"
			local atuin_opts="--cmd-only"
			local fzf_opts=(
				--height="${FZF_TMUX_HEIGHT:-80%}"
				--tac
				"-n2..,.."
				"--scheme=history"
				"--query=${LBUFFER}"
				"+m"
				"--bind=ctrl-d:reload(atuin search $atuin_opts -c $PWD),ctrl-r:reload(atuin search $atuin_opts)"
			)

			selected=$(
				eval "atuin search ${atuin_opts}" |
					fzf "${fzf_opts[@]}"
			)
			local ret=$?
			if [ -n "$selected" ]; then
				# the += lets it insert at current pos instead of replacing
				LBUFFER+="${selected}"
			fi
			zle reset-prompt
			return $ret
		}
		zle -N fzf-atuin-history-widget
		bindkey '^R' fzf-atuin-history-widget
	}
	atuin-setup
}

# https://direnv.net/docs/hook.html
eval "$(direnv hook zsh)"

setopt globdots

export EDITOR=nvim
export VISUAL=nvim

# The next line updates PATH for the Google Cloud SDK.
# shellcheck disable=SC1090
if [ -f "$HOME/Downloads/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/Downloads/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
# shellcheck disable=SC1090
if [ -f "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc"; fi

# nvm
export NVM_DIR="$HOME/.nvm"
# shellcheck disable=SC1090
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
# shellcheck disable=SC1090
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# include my non-shell-specific code
# shellcheck source=topherrc
source "$HOME"/topherrc
# shellcheck source=graphiterc
source "$HOME"/graphiterc
# shellcheck source=condarc
source "$HOME"/condarc
# shellcheck source=memfaultrc
source "$HOME"/memfaultrc
if [[ -f "$HOME"/Downloads/secretsrc ]]; then
	# shellcheck disable=SC1090
	source "$HOME"/Downloads/secretsrc
fi
if [[ -f "$HOME"/systemrc ]]; then
	# shellcheck disable=SC1090
	source "$HOME"/systemrc
fi
