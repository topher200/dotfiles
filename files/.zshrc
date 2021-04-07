export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME=""

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="false"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="false"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=~/zsh-custom

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    autojump
    git
    github
    httpie
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
source $ZSH_CUSTOM/plugins/fzf-tab/fzf-tab.plugin.zsh

# make sure our locale can handle unicode chars in prompt
export LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

# create .zsh_functions dir (https://github.com/jwilm/alacritty/blob/master/INSTALL.md#zsh)
mkdir -p ${ZDOTDIR:-~}/.zsh_functions
fpath+=${ZDOTDIR:-~}/.zsh_functions

# don't share command history between non-closed shells
unsetopt share_history

# don't autojump into directories
unsetopt autocd

# just run commands with '!!' (like 'sudo !!'), don't try to verify
setopt no_histverify

# auto complete suggestions
source $ZSH_CUSTOM/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export ZSH_AUTOSUGGEST_STRATEGY='match_prev_cmd'
source $ZSH_CUSTOM/zsh-autosuggestions/zsh-autosuggestions.zsh
# speed up pasting. https://github.com/zsh-users/zsh-autosuggestions/issues/141
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=5

# tmuxinator auto completions
source $ZSH_CUSTOM/tmuxinator.zsh

# add 'pure-prompt'
fpath+=("$ZSH_CUSTOM/pure")
autoload -U promptinit; promptinit
PURE_GIT_UNTRACKED_DIRTY=0
PURE_GIT_PULL=0
PURE_CMD_MAX_EXEC_TIME=1
zstyle ':prompt:pure:virtualenv' color green
prompt pure
# set -o vi
bindkey -v
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
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
export FZF_CTRL_T_COMMAND='ag --hidden --ignore .git -g ""'
# use fzf-tmux
export FZF_TMUX_OPTS='-d 30%'
# add fzf keybindings
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# include my non-shell-specific code
source "$HOME"/.topherrc

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/Downloads/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/Downloads/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc"; fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/topher/dev/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/topher/dev/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/home/topher/dev/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/home/topher/dev/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# memfault
export GEMFURY_DEPLOY_TOKEN=***REMOVED***
export MEMFAULT_EMAIL=user@example.com
export MEMFAULT_PASSWORD=asdf
export MEMFAULT_ORG=acme-inc

enable-fzf-tab
