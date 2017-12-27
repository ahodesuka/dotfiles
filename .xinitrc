## SETTINGS ##
xset m 1 1
xset r rate 250 50
xdotool mousemove 840 525
nvidia-settings -l

## ENV VARIABLES ##
export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on"
export QT_QPA_PLATFORMTHEME="qt5ct"
export XMODIFIERS="@im=ibus"
export GTK_IM_MODULE="ibus"
export QT_IM_MODULE="ibus"
export BROWSER="/usr/bin/palemoon-bin"
export EDITOR="/usr/bin/vim"

## DAEMONS ##
compton -b
mpd
/usr/bin/thunar --daemon &
ibus-daemon -drx
[ -z $(pidof transmission-daemon) ] && transmission-daemon

## PROGRAMS ##
irc-start       &
parcellite      &
thunderbird     &
steam -silent   &
discord         &
[ $(date +%j) -ge 355 -o $(date +%j) -le 10 ] && xsnow -ssnowdepth 8 &

## WM ##
case $1 in
*)
    exec awesome >> ~/.cache/awesome/stdout 2>> ~/.cache/awesome/stderr
    ;;
esac
