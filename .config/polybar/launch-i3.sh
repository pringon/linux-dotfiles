#!/usr/bin/env sh

# Kill all running polybar instances
killall -q polybar
# Wait until they terminate
sleep 1
#Run polybar on all monitors
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar -c ~/.config/polybar/config i3-status -r &
  done
else
  polybar --reload example &
fi
