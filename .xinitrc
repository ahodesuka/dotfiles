## SETTINGS ##
xset m 1 2
xset r rate 250 50
xset -r 172 # disable key repeat on XF86AudioPlay (pause/play)

## GLOBALS ##
export XMODIFIERS="@im=SCIM"
export GTK_IM_MODULE="scim"
export QT_IM_MODULE="scim"
export BROWSER="nightly"
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
irc-start       &
mpdas           &

## WM ##
case $1 in
*)
    exec /usr/bin/awesome
    ;;
esac
