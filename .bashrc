# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000
export HISTCONTROL=ignoredups

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    TERM=xterm-256color
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias ll='ls -halp --color=auto'
fi

alias rr='rm -rf'

# Set Vim as default editor.
export VISUAL=nvim
export EDITOR=nvim

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

alias pip='pip3'
alias vim='nvim'

# Add pip packages to path
export PATH="$PATH:~/.local/bin"
# Add go to path.
export PATH="$PATH:/usr/local/go/bin"
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
# Add ruby to path.
export PATH="$PATH:/home/pringon/.gem/ruby/2.7.0/bin"

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

if [ -r /usr/share/git/git-prompt.sh ]; then
    # Arch Linux
    source /usr/share/git/git-prompt.sh
elif [ -r /usr/share/git-core/contrib/completion/git-prompt.sh ]; then
    # Fedora
    source /usr/share/git-core/contrib/completion/git-prompt.sh
elif [ -r /etc/bash_completion.d/git-prompt ]; then
    # Ubuntu
    source /etc/bash_completion.d/git-prompt
fi

PS1='\[\033[0;32m\]\[\033[0m\033[0;32m\]\u@\h \[\033[0;36m\]\w\[\033[0;32m\]$(__git_ps1)\n\[\033[0;32m\]└─\[\033[0m\033[0;32m\] \$\[\033[0m\033[0;32m\] ▶\[\033[0m\] '

# fnm
export PATH=~/.fnm:$PATH
eval "`fnm env --multi`"

# Add GPG key
export GPG_TTY=$(tty)