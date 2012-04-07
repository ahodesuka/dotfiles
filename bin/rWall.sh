#! /bin/bash
WALLPAPERS="/mnt/dD/My Pictures/Backgrounds/mokou"
ALIST=( `ls -w1 "$WALLPAPERS"` )
RANGE=${#ALIST[@]}
let "number = $RANDOM"
let LASTNUM="`cat "$WALLPAPERS"/.last` + $number"
let "number = $LASTNUM % $RANGE"
echo $number > "$WALLPAPERS"/.last
nitrogen --set-scaled --save "$WALLPAPERS/${ALIST[$number]}"
exit
