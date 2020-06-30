# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000
# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
# append to the history file, don't overwrite it
shopt -s histappend

PS1='\[\033[0;32m\]\[\033[0m\033[0;32m\]\u@\h \[\033[0;36m\]\w\[\033[0;32m\]$(__git_ps1)\n\[\033[0;32m\]└─\[\033[0m\033[0;32m\] \$\[\033[0m\033[0;32m\] ▶\[\033[0m\] '

# Set Neovim as default editor
export VISUAL=nvim
export EDITOR=nvim

# Enable git prompt support
. /usr/share/git/git-prompt.sh

# Add relevant binaries to path
export PATH="${PATH}:${HOME}/bin"
export PATH="${PATH}:${HOME}/.emacs.d/bin"
export PATH="${PATH}:${HOME}/.local/bin"
export PATH="${PATH}:/usr/local/go/bin"
export GOPATH="${HOME}/dev/go"
export PATH="${PATH}:${HOME}/.gem/ruby/2.7.0/bin"
export PATH="${PATH}:${HOME}/.fnm"
eval "$(fnm env --multi)"
. ~/.fzf.bash

# Add GPG key
export GPG_TTY=$(tty)

# Utility aliases
alias ls='ls --color=auto'
alias ll='ls -hlp --color=auto'
alias la='ls -halp --color=auto'
alias cat='bat'
alias vim='nvim'
if command -v devour > /dev/null 2>&1; then
  alias evince='devour evince'
  alias libreoffice='devour libreoffice'
  alias sxiv='devour sxiv'
  alias mpv='devour mpv'
fi
