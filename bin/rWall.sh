#!/bin/bash

STIME="60m"
WALLDIR="$HOME/Pictures/Backgrounds/mokou"

for pid in $(pgrep $(basename $0)); do
    if [ "$pid" != "$$" ]; then
        kill -TERM -$pid;
    fi
done

if [ "$1" == "next" -a -f "/tmp/.rWall" ]; then
    c=$(cat "/tmp/.rWall");
fi

while true; do
    for n in "$WALLDIR"/*; do
        if [ -n "$c" -a "$c" != "$n" ]; then
            continue;
        elif [ "$c" == "$n" ]; then
            unset c;
            continue;
        fi
        nitrogen --set-scaled --save "$n"
        $(echo "$n" > "/tmp/.rWall")
        sleep $STIME
    done
done

exit
