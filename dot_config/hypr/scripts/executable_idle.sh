#!/usr/bin/env bash

# lock after 10 mins, turn off monitor after 15 mins // install swayidle
swayidle -w \
	timeout 600 'swaylock' \
	timeout 900 'hyprctl dispatch dpms off' \
	resume 'hyprctl dispatch dpms on'
