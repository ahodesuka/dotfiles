## SETTINGS ##
xset m 1 2
xset r rate 250 50
nvidia-settings --load-config-only

## GLOBALS ##
export __GL_SYNC_DISPLAY_DEVICE="DFP-2"
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
skype           &

## WM ##
case $1 in
*)
    exec /usr/bin/awesome
    ;;
esac
