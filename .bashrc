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

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias ll='ls -halp --color=auto'
fi

# Set Vim as default editor.
export VISUAL=nvim
export EDITOR=nvim

# enable programmable completion features
if [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

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


alias pip='pip3'
alias vim='nvim'

# Add user written scripts to path
export PATH="$PATH:~/bin"
# Add doom-emacs binaries to path
export PATH="$PATH:~/.emacs.d/bin"
# Add pip packages to path
export PATH="$PATH:~/.local/bin"
# Add go to path.
export PATH="$PATH:/usr/local/go/bin"
# Add ruby to path.
export PATH="$PATH:/home/pringon/.gem/ruby/2.7.0/bin"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# fnm
export PATH=~/.fnm:$PATH
eval "`fnm env --multi`"

# Add GPG key
export GPG_TTY=$(tty)
