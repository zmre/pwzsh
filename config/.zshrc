typeset -U path cdpath fpath manpath
autoload -U compinit

#source /nix/store/f6mza8vsg1nhl2yc8hv8c6rxgl6gard2-zsh-autosuggestions-0.7.0/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  #. /nix/store/mny6hp4sf7p822gd5y2i0b7z3mh7dy2r-fzf-0.34.0/share/fzf/completion.zsh
  #. /nix/store/mny6hp4sf7p822gd5y2i0b7z3mh7dy2r-fzf-0.34.0/share/fzf/key-bindings.zsh
#eval "$(/nix/store/0v4x7gw7vgqrm80rdcnaz43frfx6131g-zoxide-0.8.3/bin/zoxide init zsh )"
#eval "$(zoxide init zsh)"
#eval "$(/nix/store/ykfxc8b3visxza0afy472s9si41y801k-direnv-2.32.1/bin/direnv hook zsh)"

HISTSIZE="10000"
SAVEHIST="10000"

setopt HIST_FCNTL_LOCK
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST
unsetopt SHARE_HISTORY
unsetopt EXTENDED_HISTORY

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export TERM="xterm-256color"
export KEYTIMEOUT=1
export EDITOR="nvim"
export VISUAL="nvim"
export GIT_EDITOR="nvim"
export LS_COLORS="no=00:fi=00:di=01;34:ln=35;40:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=01;32:*.cmd=01;32:*.exe=01;32:*.com=01;32:*.btm=01;32:*.bat=01;32:"
export LSCOLORS="ExfxcxdxCxegedabagacad"
export FIGNORE="*.o:~:Application Scripts:CVS:.git"
export TZ="America/Denver"
export LESS="--raw-control-chars -FXRadeqs -P--Less--?e?x(Next file: %x):(END).:?pB%pB%."
export CLICOLOR=1
export CLICOLOR_FORCE="yes"
export PAGER="less"
# Add colors to man pages
export MANPAGER="less -R --use-color -Dd+r -Du+b +Gg -M -s"
export SYSTEMD_COLORS="true"
export FZF_CTRL_R_OPTS="--sort --exact"


set -o vi
bindkey -v

# Setup preferred key bindings that emulate the parts of
# emacs-style input manipulation that I'm familiar with
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '\e^h' backward-kill-word
bindkey '\e^?' backward-kill-word
bindkey '^r' history-incremental-search-backward
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '\eb' backward-word
bindkey '\ef' forward-word
bindkey '^k' kill-line
bindkey '^u' backward-kill-line

# I prefer for up/down and j/k to do partial searches if there is
# already text in play, rather than just normal through history
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
bindkey -M vicmd 'k' up-line-or-search
bindkey -M vicmd 'j' down-line-or-search
bindkey '^r' history-incremental-search-backward
bindkey '^s' history-incremental-search-forward

# You might not like what I'm doing here, but '/' works like ctrl-r
# and matches as you type. I've added pattern matches here though.

bindkey -M vicmd '/' history-incremental-pattern-search-backward # default is vi-history-search-backward
bindkey -M vicmd '?' vi-history-search-backward # default is vi-history-search-forward

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line

zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*' menu select
zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   true
zstyle ':completion:*:man:*'      menu yes select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#CVS'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always
# TODO: need to look this up as below is broken
zstyle -e ':completion:*:default' list-colors 'reply=("$${PREFIX:+=(#bi)($PREFIX:t)(?)*==34=34}:${(s.:.)LS_COLORS}")'

# taskwarrior
zstyle ':completion:*:*:task:*' verbose yes
zstyle ':completion:*:*:task:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:*:task:*' group-name '\'

zmodload -a colors
# TODO: need to look this up as below is broken
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} # complete with same colors as ls
zstyle ':completion:*:*:*:*:hosts' list-colors '=*=1;36' # bold cyan
zstyle ':completion:*:*:*:*:users' list-colors '=*=36;40' # dark cyan on black

setopt list_ambiguous

zmodload -a autocomplete
zmodload -a complist

bindkey '^I' fzf-completion

# Aliases
alias f='\fd -H'
alias fd='\fd -H -t d'
alias l='exa --icons --git-ignore --git -F --extended'
alias ll='exa --icons --git-ignore --git -F --extended -l'
alias llt='exa --icons --git-ignore --git -F --extended -l -T'
alias ls='ls --color=auto -F'
alias lt='exa --icons --git-ignore --git -F --extended -T'
alias n='zk edit --interactive'

