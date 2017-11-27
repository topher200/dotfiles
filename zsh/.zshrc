# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# run tmux in all shells
if which tmux >/dev/null 2>&1; then
    # if not inside a tmux session, and if no session is started, start a new session
    test -z "$TMUX" && ( tmux )
fi

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="jreese"

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
COMPLETION_WAITING_DOTS="true"

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
    fasd
    git
    vi-mode
)

# fasd aliases
alias j='fasd_cd -d'     # cd, same functionality as j in autojump
alias jj='fasd_cd -d -i' # cd with interactive selection

source $ZSH/oh-my-zsh.sh

# set up git template directory
GIT_TEMPLATE_DIR=~/git_template

# tig aliases
source /usr/local/etc/bash_completion.d/tig-completion.bash

# git aliases
alias gap="git add -p"
alias gau="git add -u"
alias gb="git branch"
alias gbb="git bisect bad"
alias gbg="git bisect good"
alias gbr="git bisect reset"
alias gc="git commit -v"
alias gcf="git commit -v -m fix"
alias gcnv="git commit -v --no-verify"
alias gca="git commit -va"
alias gcanv="git commit -va --no-verify"
alias gcaa="git commit -va --amend"
alias gcaf="git commit -va -m \"fix\""
alias gco="git checkout"
alias gcom="git checkout master"
alias gcoom="git checkout origin/master"
alias gcoum="git checkout upstream/master"
alias gcopa="git checkout --patch"
alias gcpa="git commit -v --patch"
alias gd="git diff --color"
alias gds="git diff --staged --color"
alias gf="git fetch"
alias gk="gitk"
alias gkm="gitk master"
alias gkom="gitk origin/master"
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gps="git push"
alias gpso="git push origin"
alias gpsoh="git push origin HEAD"
alias gpl="git pull"
alias gplr="git pull -r"
alias gr="git rebase"
alias gra="git rebase --abort"
alias grc="git rebase --continue"
alias grh="git reset HEAD"
alias grm="git rebase master"
alias grmi="git rebase master -i"
alias grom="git rebase origin/master"
alias gromi="git rebase origin/master -i"
alias grs="git rebase --skip"
alias gs="git status -s"
alias gst="git stash"
alias gsta="git stash apply"
alias gstd="git stash drop"
alias gstp="git stash pop"
alias gstpa="git stash --patch"
alias gsts="git stash show -v"
alias gsu="git submodule update --init"

# list branches, sorting by time of last commit
function glb {
    for k in `git branch|sed s/^..//`
    do
        echo -e `git log -1 --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" "$k"`\\t"$k"
    done | sort
}

# Delete the current branch you're on, leaving you on a deteched HEAD
function gdcb {
    branch_name=`git symbolic-ref HEAD --short`
    current_rev=`git rev-parse HEAD`
    git checkout $current_rev
    git branch -D $branch_name
}

# go pathing
export GOPATH=~/dev/go
export PATH=$PATH:$GOPATH/bin

# add ruby bin location to path. otherwise we use OSX's (ewww)
export PATH=/usr/local/bin:$PATH

# add my binaries to path
export PATH=$PATH:~/dev/bin

# python virtualenv
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/dev
source /usr/local/bin/virtualenvwrapper.sh

### pet (command line snippet manager)
# save previous command to pet
function petme() {
    PREV=$(fc -lrn | head -n 1)
    sh -c "pet new `printf %q "$PREV"`"
}
# search pets
function pet-select() {
    BUFFER=$(pet search --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle redisplay
}
zle -N pet-select
stty -ixon
bindkey '^s' pet-select

# wordstream specfic stuffs
if [ -f ~/wordstream-default-bashrc ]; then
    source ~/wordstream-default-bashrc
fi
alias wow="workon wordstream"
alias gcosdm="git checkout stable_db_migration"
alias gcoosdm="git checkout origin/stable_db_migration"
alias grosdm="git rebase origin/stable_db_migration"
alias gkosdm="gitk origin/stable_db_migration"
alias ss="start-servers.sh"
hot-fix-patch() {
    case "$3" in
	      "manager")
	          SERVER_PATH="wordstream_manager"
	          ;;
	      "pages")
	          SERVER_PATH="wordstream_pages"
	          ;;
	      *)
	          SERVER_PATH="wordstream"
	          ;;
    esac
    { git diff --no-ext-diff $1 $2 | perl -p -e \
	                                        'BEGIN {$server_path=shift @ARGV;}
         s@(?<=[ab])/server/([^/]+)/src@/opt/\1@g;
	 s@(?<=[ab])/client/(manager|pages)/src@/opt/wordstream_\1@g;
	 s@(?<=[ab])/python_shared/(wsframework|webapp_framework)/src@/opt/$server_path@g;' -- $SERVER_PATH
    } > /tmp/patch_file_$(date +"%Y%m%d").patch
}

# itermocil autocompletion
compctl -g '~/.itermocil/*(:t:r)' itermocil

# install thefuck
eval $(thefuck --alias)

# add supervisor for WS
alias sv='supervisorctl -c ~/dev/bin/supervisor.conf'
alias svs='supervisorctl -c ~/dev/bin/supervisor.conf status'
alias svu='supervisorctl -c ~/dev/bin/supervisor.conf update'
alias svr='supervisorctl -c ~/dev/bin/supervisor.conf restart'
alias svra='supervisorctl -c ~/dev/bin/supervisor.conf restart main:'
alias svraa='supervisorctl -c ~/dev/bin/supervisor.conf restart all'
alias svrm='supervisorctl -c ~/dev/bin/supervisor.conf restart main:manager'
alias svre='supervisorctl -c ~/dev/bin/supervisor.conf restart main:engine'

# auto complete suggestions
source $ZSH_CUSTOM/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export ZSH_AUTOSUGGEST_STRATEGY='match_prev_cmd'
source $ZSH_CUSTOM/zsh-autosuggestions/zsh-autosuggestions.zsh

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# tmuxinator auto completions
source $ZSH_CUSTOM/tmuxinator.zsh
