local ret_status="%(?:%{$fg_bold[blue]%}└─%{$fg_bold[green]%}$:%{$fg_bold[blue]%}└─%{$fg_bold[red]%}$)"
PROMPT='%{$fg_bold[blue]%}┌──(%{$fg_bold[magenta]%}%m%{$fg_bold[blue]%}) %{$fg_bold[cyan]%}%~%{$fg_bold[blue]%} 
${ret_status}%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
