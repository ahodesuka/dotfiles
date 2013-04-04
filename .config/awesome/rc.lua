local tags      = { }
local statusbar = { }
local promptbox = { }
local taglist   = { }
local layoutbox = { }
local settings  = { }

require("beautiful")
require("awful")
require("awful.autofocus")
require("awful.rules")
require("vicious")
require("naughty")
require("awesompd/awesompd")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.add_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

settings.modkey     = "Mod4"
settings.term       = "urxvt"
settings.browser    = "nightly"
settings.fileman    = "thunar"
settings.dateformat = "%Y.%m.%d %H:%M:%S"
settings.configdir  = awful.util.getdir("config")
settings.new_wall   = "rWall new"
settings.layouts    =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile
}

beautiful.init(settings.configdir .. "/ahoka/theme.lua")

mm = awful.menu({
    items =
    {
        { settings.term,    settings.term,      theme.menu_terminal },
        { settings.browser, settings.browser,   theme.menu_wbrowser },
        { settings.fileman, settings.fileman,   theme.menu_fbrowser },
        { "random bg", settings.new_wall,       theme.menu_rwall    },
        { "suspend",  "gksu pm-suspend",        theme.menu_suspend  },
        { "reboot",   "gksu 'shutdown -r now'", theme.menu_reboot   },
        { "shutdown", "gksu 'shutdown -h now'", theme.menu_shutdown }
    }
})


naughty.config.default_preset.timeout = 5
naughty.config.default_preset.screen = 2
naughty.config.default_preset.position = "top_right"

tasklist = {}
tasklist.buttons = awful.util.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else if not c:isvisible() then
            awful.tag.viewonly(c:tags()[1])
        end
        client.focus = c
        c:raise()
    end
    end),
    awful.button({ }, 3, function ()
        if instance then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ width = 250 })
        end
    end),
    awful.button({ }, 4, function ()
        awful.client.focus.byidx(1)
        if client.focus then client.focus:raise() end
    end),
    awful.button({ }, 5, function ()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
    end)
)

tags.settings = {
    { name = "東", layout = settings.layouts[1], mwfact = .65 },
    { name = "南", layout = settings.layouts[1], mwfact = .65 },
    { name = "西", layout = settings.layouts[2], mwfact = .65 },
    { name = "北", layout = settings.layouts[2], mwfact = .65 }
}

for s = 1, screen.count() do
    tags[s] = {}
    for i, v in ipairs(tags.settings) do
        tags[s][i] = tag({ name = v.name })
        tags[s][i].screen = s
        awful.tag.setproperty(tags[s][i], "layout", v.layout)
        awful.tag.setproperty(tags[s][i], "mwfact", v.mwfact)
        awful.tag.setproperty(tags[s][i], "hide",   v.hide)
    end
    tags[s][1].selected = true
end

separator           = widget({ type = "textbox" })
mpdwidget           = widget({ type = "textbox" })
cpuwidget           = widget({ type = "textbox" })
cpuwidget.width     = 28
cputempwidget       = widget({ type = "textbox" })
cputempwidget.width = 28
memwidget           = widget({ type = "textbox" })
memwidget.width     = 36
memwidget.align     = "center"
netdownwidget       = widget({ type = "textbox" })
netdownwidget.width = 56
netdownwidget.align = "center"
netupwidget         = widget({ type = "textbox" })
netupwidget.width   = 48
netupwidget.align   = "center"
clockwidget         = widget({ type = "textbox" })
clockwidget.width   = 91
clockwidget.align   = "center"

mpdicon         = widget({ type = "imagebox" })
cpuicon         = widget({ type = "imagebox" })
tempicon        = widget({ type = "imagebox" })
memicon         = widget({ type = "imagebox" })
netdownicon     = widget({ type = "imagebox" })
netupicon       = widget({ type = "imagebox" })
clockicon       = widget({ type = "imagebox" })

separator.text      = "<span color='#444'> | </span>"
mpdicon.image       = image(beautiful.widget_mpd)
cpuicon.image       = image(beautiful.widget_cpu)
tempicon.image      = image(beautiful.widget_cputemp)
memicon.image       = image(beautiful.widget_mem)
netdownicon.image   = image(beautiful.widget_net)
netupicon.image     = image(beautiful.widget_netup)
clockicon.image     = image(beautiful.widget_clock)

vicious.register(cpuwidget, vicious.widgets.cpu, " $1% ", 1)
vicious.register(cputempwidget, vicious.widgets.thermal, " $1°C", 1, { "coretemp.0", "core" })
vicious.register(memwidget, vicious.widgets.mem, " $2mb", 1)
vicious.register(netdownwidget, vicious.widgets.net, " ${eth0 down_kb}kb/s", 1)
vicious.register(netupwidget, vicious.widgets.net, "${eth0 up_kb}kb/s ", 1)
vicious.cache(vicious.widgets.net)
vicious.register(clockwidget, vicious.widgets.date, " " .. settings.dateformat, 1)

mpdwidget                   = awesompd:create()
mpdwidget.font              = beautiful.font
mpdwidget.scrolling         = false
mpdwidget.update_interval   = 1
mpdwidget.path_to_icons     = awful.util.getdir("config") .. "/ahoka/icons/awesompd"
mpdwidget.mpd_config        = "/home/mokou/.mpd/mpd.conf"
mpdwidget.album_cover_size  = 40
mpdwidget.browser           = settings.browser
mpdwidget.ldecorator        = ""
mpdwidget.rdecorator        = ""
mpdwidget:register_buttons({
    { "", awesompd.MOUSE_LEFT, mpdwidget:command_playpause() },
  	{ "", awesompd.MOUSE_SCROLL_UP, mpdwidget:command_volume_up() },
  	{ "", awesompd.MOUSE_SCROLL_DOWN, mpdwidget:command_volume_down() },
  	{ "", awesompd.MOUSE_RIGHT, mpdwidget:command_show_menu() }
})
mpdwidget:run()

systray = widget({ type = "systray" })

taglist.buttons = awful.util.table.join(
    awful.button({ }, 1, awful.tag.viewonly),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ settings.modkey }, 1, awful.client.movetotag),
    awful.button({ settings.modkey }, 3, awful.client.toggletag),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
)

for s = 1, screen.count() do
    promptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    layoutbox[s] = awful.widget.layoutbox(s)
    layoutbox[s]:buttons(awful.util.table.join(
                         awful.button({ }, 1, function () awful.layout.inc(settings.layouts, 1) end),
                         awful.button({ }, 3, function () awful.layout.inc(settings.layouts, -1) end)
    ))
    taglist[s] = awful.widget.taglist.new(s, awful.widget.taglist.label.all, taglist.buttons)
    tasklist[s] = awful.widget.tasklist(function(c)
		local tmptask = { awful.widget.tasklist.label.currenttags(c, s) }
		return tmptask[1], tmptask[2], tmptask[3], nil
    end, tasklist.buttons)
    statusbar[s] = awful.wibox(
    {
        position = "top",
        height = "16",
        fg = beautiful.fg_normal,
        bg = beautiful.bg_normal,
        screen = s
    })
    if s == 1 then
        statusbar[s].widgets =
        {
            taglist[s],
            promptbox[s],
            layoutbox[s],
            tasklist[s],
            layout = awful.widget.layout.horizontal.leftright
        }
    else
        statusbar[s].widgets =
        {
            {
                taglist[s],
                promptbox[s],
                layoutbox[s],
                layout = awful.widget.layout.horizontal.leftright
            },
            systray,
            separator,
            clockwidget,
            clockicon,
            separator,
            netupicon,
            netupwidget,
            netdownwidget,
            netdownicon,
            separator,
            memwidget,
            memicon,
            separator,
            cputempwidget,
            tempicon,
            cpuwidget,
            cpuicon,
            separator,
            mpdwidget.widget,
            mpdicon,
            tasklist[s],
            layout = awful.widget.layout.horizontal.rightleft
        }
    end
end

root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mm:toggle() end),
    awful.button({ }, 8, function () awful.util.spawn_with_shell("mpc prev") end),
    awful.button({ }, 9, function () awful.util.spawn_with_shell("mpc next") end),
    awful.button({ }, 10,function () awful.util.spawn_with_shell("mpc toggle") end)
))

local globalkeys = awful.util.table.join(
    awful.key({ settings.modkey            }, "Left",  awful.tag.viewprev),
    awful.key({ settings.modkey            }, "Right", awful.tag.viewnext),
    awful.key({ settings.modkey,           }, "Escape",awful.tag.history.restore),
    awful.key({ settings.modkey            }, "w",     function () awful.util.spawn_with_shell(settings.new_wall) end),
    awful.key({ settings.modkey            }, "x",     function () awful.util.spawn(settings.term) end),
    awful.key({ settings.modkey            }, "f",     function () awful.util.spawn(settings.browser) end),
    awful.key({ settings.modkey            }, "e",     function () awful.util.spawn(settings.fileman) end),
    awful.key({ settings.modkey, "Control" }, "r",     awesome.restart),
    awful.key({ settings.modkey, "Shift"   }, "q",     awesome.quit),
    awful.key({ settings.modkey,           }, "j",     function ()
        awful.client.focus.byidx( 1)
        if client.focus then client.focus:raise() end
    end),
    awful.key({ settings.modkey,           }, "k",     function ()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
    end),
    awful.key({ settings.modkey, "Shift"   }, "j",    function () awful.client.swap.byidx(1) end),
    awful.key({ settings.modkey, "Shift"   }, "k",    function () awful.client.swap.byidx(-1) end),
    awful.key({ settings.modkey, "Control" }, "j",    function () awful.screen.focus_relative(1) end),
    awful.key({ settings.modkey, "Control" }, "k",    function () awful.screen.focus_relative(-1) end),
    awful.key({ settings.modkey,           }, "u",    awful.client.urgent.jumpto),
    awful.key({ settings.modkey,           }, "Tab",  function ()
        awful.client.focus.history.previous()
        if client.focus then client.focus:raise() end
    end),
    awful.key({ settings.modkey            }, "l",     function () awful.tag.incmwfact(0.025) end),
    awful.key({ settings.modkey            }, "h",     function () awful.tag.incmwfact(-0.025) end),
    awful.key({ settings.modkey, "Shift"   }, "h",     function () awful.client.incwfact(0.05) end),
    awful.key({ settings.modkey, "Shift"   }, "l",     function () awful.client.incwfact(-0.05) end),
    awful.key({ settings.modkey, "Control" }, "h",     function () awful.tag.incnmaster(1) end),
    awful.key({ settings.modkey, "Control" }, "l",     function () awful.tag.incnmaster(-1) end),
    awful.key({ settings.modkey            }, "space", function () awful.layout.inc(settings.layouts, 1) end),
    awful.key({ settings.modkey, "Shift"   }, "space", function () awful.layout.inc(settings.layouts, -1) end),
    awful.key({ settings.modkey            }, "r",     function () promptbox[mouse.screen]:run() end),
    awful.key({ }, "XF86AudioPlay", function () awful.util.spawn_with_shell("mpc toggle") end)
)

local clientkeys = awful.util.table.join(
    awful.key({ settings.modkey            }, "c",     function (c) c:kill() end),
    awful.key({ settings.modkey, "Control" }, "space", awful.client.floating.toggle),
    awful.key({ settings.modkey, "Shift"   }, "r",     function (c) c:redraw() end),
    awful.key({ settings.modkey            }, "m",     function (c)
        c.maximized_horizontal = not c.maximized_horizontal
        c.maximized_vertical   = not c.maximized_vertical
    end)
)

keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ settings.modkey }, "#" .. i + 9, function ()
            local screen = mouse.screen
            if tags[screen][i] then
                awful.tag.viewonly(tags[screen][i])
            end
        end),
        awful.key({ settings.modkey, "Control" }, "#" .. i + 9, function ()
            local screen = mouse.screen
            if tags[screen][i] then
                awful.tag.viewtoggle(tags[screen][i])
            end
        end),
        awful.key({ settings.modkey, "Shift" }, "#" .. i + 9, function ()
            if client.focus and tags[client.focus.screen][i] then
                awful.client.movetotag(tags[client.focus.screen][i])
            end
        end),
        awful.key({ settings.modkey, "Control", "Shift" }, "#" .. i + 9, function ()
            if client.focus and tags[client.focus.screen][i] then
                awful.client.toggletag(tags[client.focus.screen][i])
            end
        end)
    )
end

function nth_next_tag (n)
    return awful.util.cycle(#tags[client.focus.screen], awful.tag.getidx(awful.tag.selected(client.focus.screen)) + n)
end

local clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ settings.modkey }, 1, awful.mouse.client.move),
    awful.button({ settings.modkey }, 3, awful.mouse.client.resize),
    awful.button({ settings.modkey }, 4, function ()
        if client.focus and tags[client.focus.screen][nth_next_tag(1)] then
            awful.client.movetotag(tags[client.focus.screen][nth_next_tag(1)])
        end
        awful.tag.viewnext()
    end),
    awful.button({ settings.modkey }, 5, function ()
        if client.focus and tags[client.focus.screen][nth_next_tag(1)] then
            awful.client.movetotag(tags[client.focus.screen][nth_next_tag(-1)])
        end
        awful.tag.viewprev()
    end)
)

root.keys(globalkeys)

awful.rules.rules =
{
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     size_hints_honor = false } },
    { rule = { class = "Smplayer2" }, properties = { floating = true } },
    { rule = { class = "Thunar", name = "File Operation Progress" }, properties = { floating = true } },
    { rule = { class = "Gimp" }, properties = { floating = true } },
    { rule = { class = "Skype" }, properties = { floating = true } },
    { rule = { class = "Wine" }, properties = { floating = true, border_width = 0 } },
    { rule = { class = "Steam" }, properties = { floating = true, border_width = 0 } },
    { rule = { class = "Torchlight.bin.x86_64" }, properties = { floating = true, border_width = 0 } },
    { rule = { class = "Firefox", instance = "Browser" }, properties = { floating = true } },
    { rule = { class = "Firefox", instance = "Update" }, properties = { floating = true } },
    { rule = { class = "Firefox", instance = "Devtools" }, properties = { floating = true } },
    { rule = { instance = "TERA.exe" }, properties = { x = 0, y = 0 } },
    { rule = { instance = "plugin-container" }, properties = { floating = true } },
    { rule = { instance = "sun-awt-X11-XWindowPeer" }, properties = {
        border_width = "0",
        buttons = nil,
        keys = nil,
        floating = true
    } }
}

client.add_signal("manage", function (c, startup)
    c:add_signal("mouse::enter", function (c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
           and awful.client.focus.filter(c) then
               client.focus = c
        end
    end)

    if not startup then
        awful.client.setslave(c)
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

local oldspawn = awful.util.spawn
awful.util.spawn = function (s)
    oldspawn(s, false)
end

