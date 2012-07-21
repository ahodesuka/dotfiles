xset m 1 2
xset r rate 250 50
mpd && scrobby
export XMODIFIERS=@im="uim"
nvidia-settings --load-config-only
transmission &
cmptn &
uim-toolbar-gtk-systray &
uim-xim &
sleep 10 && urxvt -e irssi &
sleep 10 && godzillas_waifu &
exec ck-launch-session dbus-launch --sh-syntax --exit-with-session awesome
