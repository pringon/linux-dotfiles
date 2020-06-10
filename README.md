# Dotfiles

Dotfiles for my personal arch machine

# Usage

Drop dotfiles using `stow .`

## Requirements

- Fonts:
  - Hack
  - Noto Color Emoji
- neovim:
  - plug
- xmonad
  - picom
  - polybar
  - rofi
  - nitrogen

Some scripts require a `.dan-env` that holds certain secrets
I don't want to publish to github. You can find an example file
at `.dan-env.example`.

### Cron

The following cronjobs need to be set up for your current user:

```
*/15 * * * * ~/bin/sync-google-calendar
```
