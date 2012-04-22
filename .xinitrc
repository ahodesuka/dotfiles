xset m 1 2 
xset r rate 250 45 
mpd
while true; do rWall.sh; sleep 60m; done &
cmptn &
uim-xim &
uim-toolbar-gtk-systray &
exec ck-launch-session dbus-launch --exit-with-session awesome

