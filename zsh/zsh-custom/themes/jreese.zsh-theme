# ZSH Theme - Preview: http://dl.dropbox.com/u/1552408/Screenshots/2010-04-08-oh-my-zsh.png

PROMPT='%{$fg[$NCOLOR]%}%n%{$reset_color%} %~ $(git_prompt_info)$(git_prompt_status)%{$fg[red]%}%(!.#.»)%{$reset_color%} '
PROMPT2='%{$fg[red]%}\ %{$reset_color%}'

# turn off right prompt
ZLE_RPROMPT_INDENT=0

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="#"
ZSH_THEME_GIT_PROMPT_STASHED="$"
