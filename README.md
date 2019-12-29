# Dotfiles

Dotfiles for my ubuntu machine

# Usage

- In order to create symbolic links to your dotfiles just run: `./make-links`
- Make sure to copy the `Scripts` and and `pictures` directories to your home directory otherwise locking and suspending functionality will not work correctly.

## Requirements

- **terminal** urxvt:
  - Hack powerline font
- neovim:
  - plug
  - nvim (npm package)
- i3
  - i3-lock-fancy
  - the script suspend.sh to be located in ~/bin
- Bumblebee-status requires:
  - FontAwesome
  - python-tk
  - python-psutil
  - python-netifaces
