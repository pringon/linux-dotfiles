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

# Utility aliases
alias ls='ls --color=auto'
alias ll='ls -hlp --color=auto'
alias la='ls -halp --color=auto'
alias cat='bat'
alias vim='nvim'
alias sxiv='devour sxiv'
alias mpv='devour mpv'

# Add user written scripts to path
export PATH="${PATH}:${HOME}/bin"
# Add doom-emacs binaries to path
export PATH="${PATH}:${HOME}/.emacs.d/bin"
# Add pip packages to path
export PATH="${PATH}:${HOME}/.local/bin"
# Add go to path.
export PATH="${PATH}:/usr/local/go/bin"
export GOPATH="${HOME}/dev/go"
# Add ruby to path.
export PATH="${PATH}:${HOME}/.gem/ruby/2.7.0/bin"
# Add fnm to path.
export PATH="${PATH}:${HOME}/.fnm"
# This command causes fnm to create a new temporary environment
# for the current shell
eval "$(fnm env --multi)"

. ~/.fzf.bash

# Add GPG key
export GPG_TTY=$(tty)
