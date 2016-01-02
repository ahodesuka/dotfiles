## SETTINGS ##
xset m 1 2
xset r rate 250 50
xdotool mousemove 840 525
nvidia-settings -l

## ENV VARIABLES ##
export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on"
export QT_STYLE_OVERRIDE="gtk"
export XMODIFIERS="@im=ibus"
export GTK_IM_MODULE="ibus"
export QT_IM_MODULE="ibus"
export BROWSER="firefox"
export EDITOR="gvim"

## DAEMONS ##
compton -b
mpd
/usr/bin/thunar --daemon &

## PROGRAMS ##
irc-start       &
dpmscheck       &
parcellite      &
thunderbird     &
transmission -m &

## WM ##
case $1 in
*)
    exec awesome
    ;;
esac
