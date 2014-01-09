## SETTINGS ##
xset m 1 2
xset r rate 250 50
nvidia-settings -l

## ENV VARIABLES ##
export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on"
export XMODIFIERS=@im=SCIM
export GTK_IM_MODULE="scim"
export QT_IM_MODULE="scim"
export BROWSER="firefox"
export EDITOR="gvim"
export DE="xfce"

## DAEMONS ##
thunar --daemon &
nixlibsd
scim -d
cmptn
mpd

## PROGRAMS ##
transmission -m &
thunderbird     &
parcellite      &
dpmscheck       &
irc-start       &
mpdas           &

## WM ##
case $1 in
*)
    exec /usr/bin/awesome
    ;;
esac
