## SETTINGS ##
xset m 1 2
xset r rate 250 50
xdotool mousemove 840 525
nvidia-settings -l
rWall &

## ENV VARIABLES ##
export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on"
export XMODIFIERS=@im=SCIM
export GTK_IM_MODULE="scim"
export QT_IM_MODULE="scim"
export BROWSER="firefox"
export EDITOR="gvim"
export DE="xfce"

## DAEMONS ##
compton -b
mpd
scim -d

## PROGRAMS ##
irc-start       &
dpmscheck       &
parcellite      &
thunderbird     &
transmission -m &

## WM ##
case $1 in
*)
    exec /usr/bin/awesome
    ;;
esac
