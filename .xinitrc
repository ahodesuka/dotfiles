## SETTINGS ##
xset m 1 2
xset r rate 250 50
nvidia-settings --load-config-only

## GLOBALS ##
export XMODIFIERS="@im=SCIM"
export GTK_IM_MODULE="scim"
export QT_IM_MODULE="scim"

## DAEMONS ##
thunar --daemon &
nixlibsd
cmptn
scim -d
mpd

## PROGRAMS ##
transmission -m &
thunderbird     &
parcellite      &
mpdas           &
irc-start       &

## WM ##
exec ck-launch-session dbus-launch --sh-syntax --exit-with-session /usr/bin/awesome
