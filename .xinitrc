## SETTINGS ##
xset m 1 1
xset r rate 250 50
xdotool mousemove 840 525
nvidia-settings -l

## ENV VARIABLES ##
export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on"
export QT_STYLE_OVERRIDE="gtk"
export XMODIFIERS="@im=ibus"
export GTK_IM_MODULE="ibus"
export QT_IM_MODULE="ibus"
export BROWSER="/usr/bin/palemoon-bin"
export EDITOR="/usr/bin/gvim"

## DAEMONS ##
compton -b
mpd
/usr/bin/thunar --daemon &
ibus-daemon -drx
transmission-daemon

## PROGRAMS ##
irc-start       &
parcellite      &
thunderbird     &
ckb -b          &
steam -silent   &

## WM ##
case $1 in
*)
    exec awesome >> ~/.cache/awesome/stdout 2>> ~/.cache/awesome/stderr
    ;;
esac
