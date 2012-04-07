xset m 1 2 
xset r rate 250 45 
mpd 
while true; do rWall.sh; sleep 60m; done &
cmptn &
xsetroot -cursor_name left_ptr &
exec ck-launch-session awesome 
