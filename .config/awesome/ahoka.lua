-------------------------------
--   ahoka's awesome theme   --
-------------------------------

theme   = {}
confdir = awful.util.getdir("config")

theme.font      = "cure 8"

theme.fg_normal = "#cccaca"
theme.fg_focus  = "#eeecec"
theme.fg_urgent = "#c7838f"
theme.bg_normal = "#222222"
theme.bg_focus  = "#161616"
theme.bg_urgent = "#161616"

theme.border_width  = "2"
theme.border_normal = "#161616"
theme.border_focus  = "#222222"
theme.border_marked = "#c7838f"

theme.titlebar_bg_focus  = "#222222"
theme.titlebar_bg_normal = "#222222"

theme.menu_height = "16"
theme.menu_border_width = "1"
theme.menu_border_color = "#161616"

theme.taglist_squares_sel   = confdir .. "/icons/taglist/squarefza.png"
theme.taglist_squares_unsel = confdir .. "/icons/taglist/squareza.png"

theme.widget_net        = confdir .. "/icons/ahoka/net_down_03.png"
theme.widget_netup      = confdir .. "/icons/ahoka/net_up_03.png"
theme.widget_clock      = confdir .. "/icons/ahoka/clock.png"
theme.widget_mem        = confdir .. "/icons/ahoka/mem.png"
theme.widget_cputemp    = confdir .. "/icons/ahoka/temp.png"
theme.widget_cpu        = confdir .. "/icons/ahoka/cpu.png"
theme.widget_mpd        = confdir .. "/icons/ahoka/note.png"

theme.layout_tile       = confdir .. "/icons/layouts/tile.png"
theme.layout_tileleft   = confdir .. "/icons/layouts/tileleft.png"
theme.layout_tilebottom = confdir .. "/icons/layouts/tilebottom.png"
theme.layout_tiletop    = confdir .. "/icons/layouts/tiletop.png"
theme.layout_fairv      = confdir .. "/icons/layouts/fairv.png"
theme.layout_fairh      = confdir .. "/icons/layouts/fairh.png"
theme.layout_spiral     = confdir .. "/icons/layouts/spiral.png"
theme.layout_dwindle    = confdir .. "/icons/layouts/dwindle.png"
theme.layout_max        = confdir .. "/icons/layouts/max.png"
theme.layout_fullscreen = confdir .. "/icons/layouts/fullscreen.png"
theme.layout_magnifier  = confdir .. "/icons/layouts/magnifier.png"
theme.layout_floating   = confdir .. "/icons/layouts/floating.png"

theme.menu_terminal     = confdir .. "/icons/menu/terminal.png"
theme.menu_wbrowser     = confdir .. "/icons/menu/wbrowser.png"
theme.menu_fbrowser     = confdir .. "/icons/menu/fbrowser.png"
theme.menu_rwall        = confdir .. "/icons/menu/rwall.png"
theme.menu_suspend      = confdir .. "/icons/menu/suspend.png"
theme.menu_reboot       = confdir .. "/icons/menu/reboot.png"
theme.menu_shutdown     = confdir .. "/icons/menu/shutdown.png"

return theme

