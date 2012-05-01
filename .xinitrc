xset m 1 2
xset r rate 250 50
mpd
export XMODIFIERS=@im="uim"
transmission &
urxvt -e irssi &
cmptn &
uim-toolbar-gtk-systray &
uim-xim &
exec ck-launch-session dbus-launch --exit-with-session awesome

