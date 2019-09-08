#!/bin/bash
ME="/home/$(whoami)"
killall -q polybar
while pgrep -u $UID -x polybar > /dev/null;do sleep 1; done
polybar --config=$ME/dotfiles/polybar/config mgz &

