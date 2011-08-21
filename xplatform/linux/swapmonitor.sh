#!/usr/bin/env bash
source header.sh

window_id=$1
if [ -z "$window_id" ]; then 
    window_id="$(xprop -root | grep "_NET_ACTIVE_WINDOW(WINDOW)" | awk -F ' window id # 0x' '{print $2}')" 
    window_id="$(wmctrl -lG | grep "$window_id" | awk -F ' ' '{print $1}')"
fi

window_props="$(wmctrl -lG | grep -E "^.*$window_id.*$")"
x=$(echo "$window_props" | awk -F ' ' '{print $3}')
y=$(echo "$window_props" | awk -F ' ' '{print $4}')
w=$(echo "$window_props" | awk -F ' ' '{print $5}')
h=$(echo "$window_props" | awk -F ' ' '{print $6}')
echo "x = $x, y = $y, w = $w, h = $h"

is_left=$(( $x < 1680 ))
is_right=$(( $x >= 1680 ))
if [ $is_right -eq 1 ]; then 
    max_x=1280
    other_max_x=1680
    max_y=1024
    other_max_y=1050
    x=$(( $x - 1680 ));
else
    max_x=1680
    other_max_x=1280
    max_y=1050
    other_max_y=1024
fi

new_x=$(echo "scale = 2; $x * $other_max_x / $max_x" | bc -q | xargs printf "%1.0f")
if [ $is_left -eq 1 ]; then new_x=$(( new_x + 1680 )); fi
#new_y=$(echo "scale = 2; $y * $other_max_y / $max_y" | bc -q | xargs printf "%1.0f")
new_y=$y
#new_w=$(echo "scale = 2; $w * $other_max_x / $max_x" | bc -q | xargs printf "%1.0f")
new_w=$w
if [ $w -eq $max_x ]; then new_w=$other_max_x; fi
#new_h=$(echo "scale = 2; $h * $other_max_y / $max_y" | bc -q | xargs printf "%1.0f")
new_h=$h
if [ $h -eq $max_y ]; then new_h=$other_max_y; fi
echo "new_x = $new_x, new_y = $new_y, new_w = $new_w, new_h = $new_h"

# take window frame into account
new_y=$(( $new_y - 46 ))
new_x=$(( $new_x - 8 ))

xdotool windowmove $window_id $new_x $new_y
xdotool windowsize $window_id $new_w $new_h
xdotool windowraise $window_id

