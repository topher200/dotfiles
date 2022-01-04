export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export ZSH=~/.oh-my-zsh
HYPHEN_INSENSITIVE="true"
zstyle ':omz:update' mode reminder
# if we want to switch to 'off':
# zstyle ':omz:update' mode disabled
DISABLE_AUTO_TITLE="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="yyyy-mm-dd"
ZSH_CUSTOM=~/zsh-custom
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(
    autojump
    github
    httpie
    poetry
    safe-paste
    thefuck
)
source $ZSH/oh-my-zsh.sh

# enable 'kitty' terminal emulator
if command -v kitty > /dev/null; then
    autoload -Uz compinit
    compinit
    kitty + complete setup zsh | source /dev/stdin
fi

source $ZSH_CUSTOM/zsh-async/async.zsh
source $ZSH_CUSTOM/invoke-completion.sh

# make sure our locale can handle unicode chars in prompt
export LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

# create .zsh_functions dir (https://github.com/jwilm/alacritty/blob/master/INSTALL.md#zsh)
mkdir -p ${ZDOTDIR:-~}/.zsh_functions
fpath+=${ZDOTDIR:-~}/.zsh_functions

# move up and down in local history, but ctrl-r uses global history
# https://superuser.com/questions/446594/separate-up-arrow-lookback-for-local-and-global-zsh-history
unsetopt inc_append_history
unsetopt inc_append_history_time
setopt sharehistory
function up-line-or-history() {
    zle set-local-history 1
    zle .up-line-or-history
    zle set-local-history 0
}

function down-line-or-history() {
    zle set-local-history 1
    zle .down-line-or-history
    zle set-local-history 0
}
zle -N up-line-or-history
zle -N down-line-or-history

# clean up extra spaces in history commands
setopt hist_reduce_blanks
unsetopt hist_ignore_space

# don't autojump into directories
unsetopt autocd

# just run commands with '!!' (like 'sudo !!'), don't try to verify
setopt no_histverify

# auto complete suggestions
source $ZSH_CUSTOM/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=bold,underline"
export ZSH_AUTOSUGGEST_USE_ASYNC=true
source $ZSH_CUSTOM/zsh-autosuggestions/zsh-autosuggestions.zsh
# speed up pasting. https://github.com/zsh-users/zsh-autosuggestions/issues/141
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=5

# tmuxinator auto completions
source $ZSH_CUSTOM/tmuxinator.zsh

# add 'pure-prompt'
fpath+=("$ZSH_CUSTOM/pure")
autoload -U promptinit; promptinit
PURE_CMD_MAX_EXEC_TIME=1
PURE_PROMPT_SYMBOL=$
PURE_PROMPT_VICMD_SYMBOL=$
PURE_GIT_UNTRACKED_DIRTY=0
zstyle :prompt:pure:virtualenv color green
zstyle :prompt:pure:git:stash show yes
prompt pure
# set -o vi
bindkey -v
# this bindkey is overriden later by fzf
bindkey '^R' history-incremental-search-backward
# 'v' enters VI mode, from https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/vi-mode/vi-mode.plugin.zsh
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line
# backspace always deletes a char, even in insert mode. from https://unix.stackexchange.com/a/368576
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^H' backward-delete-char

### pet (command line snippet manager)
# save previous command to pet
function petme() {
    PREV=$(fc -lrn | head -n 1)
    sh -c "pet new `printf %q "$PREV"`"
}
# search pets
function pet-select() {
    BUFFER=$(pet search --color --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle redisplay
}
zle -N pet-select
stty -ixon
bindkey '^s' pet-select
### end pet (command line snippet manager)

# make fzf use ag instead of its default (find)
export FZF_COMPLETION_TRIGGER='ff'
export FZF_COMPLETION_OPTS='--border --info=inline'
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
export FZF_CTRL_T_COMMAND='ag --hidden --ignore .git -g ""'
# use fzf-tmux
export FZF_TMUX_OPTS='-d 30%'
# add fzf keybindings
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh

setopt globdots

export EDITOR=nvim
export VISUAL=nvim

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/Downloads/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/Downloads/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc"; fi

# include my non-shell-specific code
source "$HOME"/topherrc
source "$HOME"/stgitrc
if [[ -f "$HOME"/Dropbox/secretsrc ]]; then
    source "$HOME"/Dropbox/secretsrc
fi
if [[ -f "$HOME"/condarc ]]; then
    source "$HOME"/condarc
fi
source "$HOME"/memfaultrc
