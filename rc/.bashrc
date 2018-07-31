# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

set -o vi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
