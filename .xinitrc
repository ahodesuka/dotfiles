## SETTINGS ##
xset m 1 2
xset r rate 250 50
nvidia-settings --load-config-only

## GLOBALS ##
export XMODIFIERS=@im="SCIM"
export GTK_IM_MODULE=scim
export QT_IM_MODULE="scim"

## DAEMONS ##
nixlibsd
mpd && scrobby
scim -d
cmptn

## PROGRAMS ##
transmission &
parcellite &
irc-start &

## WM ##
exec ck-launch-session dbus-launch --sh-syntax --exit-with-session awesome
