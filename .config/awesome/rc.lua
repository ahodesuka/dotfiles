local tags      = { }
local statusbar = { }
local promptbox = { }
local taglist   = { }
local tasklist  = { }
local layoutbox = { }
local settings  = { }

local awful     = require("awful")
awful.rules     = require("awful.rules")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local naughty   = require("naughty")
local vicious   = require("vicious")
local awesompd  = require("awesompd/awesompd")
local wallpaper = require("wallpaper")

-- autofocus:
-- When loaded, this module makes sure that there's always a client that will
-- have focus on events such as tag switching, client unmanaging, etc.
require("awful.autofocus")

-- {{{ Error handling
-- Startup
if awesome.startup_errors then
    naughty.notify({
                   preset = naughty.config.presets.critical,
                   title = "Oops, there were errors during startup!",
                   text = awesome.startup_errors
               })
end

-- Runtime
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        if in_error then return end
        in_error = true
        naughty.notify({ preset = naughty.config.presets.critical,
                       title = "Oops, an error happened!",
                       text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Settings
beautiful.init(awful.util.getdir("config") .. "/ahoka/theme.lua")

naughty.config.defaults.timeout = 5
naughty.config.defaults.screen = screen.count()
naughty.config.defaults.position = "top_right"

naughty.config.presets.critical.bg = beautiful.bg_normal
naughty.config.presets.critical.fg = beautiful.fg_urgent
naughty.config.presets.critical.border_color = beautiful.border_focus

wall = wallpaper:create({
    dir = "~/Pictures/Wallpapers/mokou",
    delay = 60 * 60 * 4, -- 4 hours
})

settings.bar_height = 16
settings.modkey     = "Mod4"
settings.term       = "urxvt"
settings.browser    = "firefox"
settings.fileman    = "thunar"
settings.taskman    = settings.term .. " -e htop"
settings.dateformat = "%Y.%m.%d %H:%M:%S"
settings.new_wall   = wall:new()
settings.layouts    =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile,
}
-- }}}

-- {{{ Tags
tags.settings = {
    {
        { name = "東", props = { layout = settings.layouts[2], mwfact = .6805 } },
        { name = "南", props = { layout = settings.layouts[2], mwfact = .6805 } },
        { name = "西", props = { layout = settings.layouts[1], mwfact = .6805 } },
        { name = "北", props = { layout = settings.layouts[1], mwfact = .6805 } },
    },
    {
        { name = "東", props = { layout = settings.layouts[1], mwfact = .6805 } },
        { name = "南", props = { layout = settings.layouts[1], mwfact = .6805 } },
        { name = "西", props = { layout = settings.layouts[2], mwfact = .6805 } },
        { name = "北", props = { layout = settings.layouts[2], mwfact = .6805 } },
    },
}

for s = 1, screen.count() do
    tags[s] = { }
    for i, v in ipairs(tags.settings[s]) do
        v.props.screen = s
        tags[s][i] = awful.tag.add(v.name, v.props)
    end
    tags[s][1].selected = true
end
-- }}}

-- {{{ Menu
menu = awful.menu({
    items =
    {
        { settings.term,    settings.term,            theme.menu_terminal },
        { settings.browser, settings.browser,         theme.menu_wbrowser },
        { settings.fileman, settings.fileman,         theme.menu_fbrowser },
        { "random bg",      settings.new_wall,        theme.menu_rwall    },
        { "suspend",        "ktsuss pm-suspend",      theme.menu_suspend  },
        { "reboot",         "ktsuss shutdown -r now", theme.menu_reboot   },
        { "shutdown",       "ktsuss shutdown -h now", theme.menu_shutdown }
    }
})
-- }}}

-- {{{ Widgets
function make_fixed_textbox(w, a, t)
    local tb = wibox.widget.textbox()
    local widget = wibox.layout.margin(tb, 0, 0, -1, 0)
    widget.tb = tb
    tb.fit = function(_, _, h) return w, h end
    if a then
        tb:set_align(a)
    end
    if t then
        tb:set_markup(t)
    end
    return widget
end

padding       = wibox.widget.textbox()
separator     = wibox.widget.textbox()
cpuwidget     = make_fixed_textbox(28)
cputempwidget = make_fixed_textbox(28)
memwidget     = make_fixed_textbox(40, "center")
netdownwidget = make_fixed_textbox(42, "center")
netupwidget   = make_fixed_textbox(42, "center")
clockwidget   = make_fixed_textbox(88, "center")

padding:set_text(" ")
separator:set_markup("<span color='#444'> | </span>")

mpdicon     = wibox.widget.imagebox(beautiful.widget_mpd)
cpuicon     = wibox.widget.imagebox(beautiful.widget_cpu)
tempicon    = wibox.widget.imagebox(beautiful.widget_cputemp)
memicon     = wibox.widget.imagebox(beautiful.widget_mem)
netdownicon = wibox.widget.imagebox(beautiful.widget_net)
netupicon   = wibox.widget.imagebox(beautiful.widget_netup)
clockicon   = wibox.widget.imagebox(beautiful.widget_clock)

vicious.register(cpuwidget.tb, vicious.widgets.cpu, " $1% ", 1)
vicious.register(cputempwidget.tb, vicious.widgets.thermal, " $1℃", 1, "thermal_zone0")
vicious.register(memwidget.tb, vicious.widgets.mem, " $2mb", 1)
vicious.register(netdownwidget.tb, vicious.widgets.net, " ${eth0 down_mb}mb/s", 1)
vicious.register(netupwidget.tb, vicious.widgets.net, "${eth0 up_mb}mb/s ", 1)
-- Need a cache since there are 2 of them
vicious.cache(vicious.widgets.net)
vicious.register(clockwidget.tb, vicious.widgets.date, " " .. settings.dateformat, 1)

-- Awesompd
mpd = awesompd:create({
    scrolling = false,
    max_width = 300,
    path_to_icons = awful.util.getdir("config") .. "/awesompd/icons",
    mpd_config = os.getenv("HOME") .. "/.config/mpd/mpd.conf",
    rdecorator = "",
    -- OSD config
    osd = {
        screen = screen.count(),
        x = -10, -- 10px from right edge
        y = settings.bar_height + 10,
        bar_bg_color = beautiful.bg_focus,
        bar_fg_color = "#a16a71", -- my icon color
        alt_fg_color = "#a49c9c",
    }
})
mpd:register_buttons({
    { "", awesompd.MOUSE_LEFT, mpd:command_playpause() },
    { "", awesompd.MOUSE_SCROLL_UP, mpd:command_volume_up() },
    { "", awesompd.MOUSE_SCROLL_DOWN, mpd:command_volume_down() },
    { "", awesompd.MOUSE_RIGHT, mpd:command_show_menu() }
})

mpdwidget = wibox.layout.margin(mpd.widget, 0, 0, -1, 0)

systray = wibox.widget.systray()

taglist.buttons = awful.util.table.join(
    awful.button({ }, 1, awful.tag.viewonly),
    awful.button({ }, 3, awful.tag.viewtoggle)
)

tasklist.buttons = awful.util.table.join(
    awful.button({ }, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else if not c:isvisible() then
            awful.tag.viewonly(c:tags()[1])
        end
        client.focus = c
        c:raise()
    end
    end),
    awful.button({ }, 2, function(c)
        c:kill()
    end),
    awful.button({ }, 3, function()
        if instance then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end),
    awful.button({ }, 4, function()
        awful.client.focus.byidx(1)
        if client.focus then client.focus:raise() end
    end),
    awful.button({ }, 5, function()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
    end)
)

for s = 1, screen.count() do
    promptbox[s] = awful.widget.prompt()
    layoutbox[s] = awful.widget.layoutbox(s)
    layoutbox[s]:buttons(awful.util.table.join(
        awful.button({ }, 1, function() awful.layout.inc(settings.layouts, 1) end),
        awful.button({ }, 3, function() awful.layout.inc(settings.layouts, -1) end)
    ))
    taglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist.buttons)
    tasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist.buttons)

    local left_layout  = wibox.layout.fixed.horizontal()
    local right_layout = wibox.layout.fixed.horizontal()
    statusbar[s] = awful.wibox(
    {
        position = "top",
        height = settings.bar_height,
        fg = beautiful.fg_normal,
        bg = beautiful.bg_normal,
        screen = s
    })
    left_layout:add(taglist[s])
    left_layout:add(promptbox[s])
    left_layout:add(layoutbox[s])
    if s == screen.count() then
        right_layout:add(padding)
        right_layout:add(mpdicon)
        right_layout:add(mpdwidget)
        right_layout:add(separator)
        right_layout:add(cpuicon)
        right_layout:add(cpuwidget)
        right_layout:add(tempicon)
        right_layout:add(cputempwidget)
        right_layout:add(separator)
        right_layout:add(memicon)
        right_layout:add(memwidget)
        right_layout:add(separator)
        right_layout:add(netdownicon)
        right_layout:add(netdownwidget)
        right_layout:add(netupwidget)
        right_layout:add(netupicon)
        right_layout:add(separator)
        right_layout:add(clockicon)
        right_layout:add(clockwidget)
        right_layout:add(separator)
        right_layout:add(systray)
    end
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(tasklist[s])
    layout:set_right(right_layout)
    statusbar[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse and Key Bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3,  function() menu:toggle() end),
    awful.button({ }, 8,  mpd:command_prev_track()),
    awful.button({ }, 9,  mpd:command_next_track()),
    awful.button({ }, 10, mpd:command_playpause())
))

local globalkeys = awful.util.table.join(
    awful.key({ settings.modkey            }, "Left",           awful.tag.viewprev),
    awful.key({ settings.modkey            }, "Right",          awful.tag.viewnext),
    awful.key({ settings.modkey,           }, "Escape",         awful.tag.history.restore),
    awful.key({ settings.modkey            }, "w",              settings.new_wall),
    awful.key({ settings.modkey            }, "x",              function() awful.spawn(settings.term)    end),
    awful.key({ settings.modkey            }, "f",              function() awful.spawn(settings.browser) end),
    awful.key({ settings.modkey            }, "e",              function() awful.spawn(settings.fileman) end),
    awful.key({ "Control", "Shift"         }, "Escape",         function() awful.spawn(settings.taskman) end),
    awful.key({ settings.modkey, "Control" }, "r",              awesome.restart),
    awful.key({ settings.modkey, "Shift"   }, "q",              awesome.quit),
    awful.key({ settings.modkey,           }, "Tab",            function()
        awful.client.focus.history.previous()
        if client.focus then client.focus:raise() end
    end),
    awful.key({ settings.modkey            }, "h",              function()
        awful.client.focus.bydirection("left")
        if client.focus then client.focus:raise() end
    end),
    awful.key({ settings.modkey            }, "j",              function()
        awful.client.focus.bydirection("down")
        if client.focus then client.focus:raise() end
    end),
    awful.key({ settings.modkey            }, "k",              function()
        awful.client.focus.bydirection("up")
        if client.focus then client.focus:raise() end
    end),
    awful.key({ settings.modkey            }, "l",              function()
        awful.client.focus.bydirection("right")
        if client.focus then client.focus:raise() end
    end),
    awful.key({ settings.modkey, "Control" }, "h",              function() awful.tag.incmwfact(0.025)             end),
    awful.key({ settings.modkey, "Control" }, "j",              function() awful.client.incwfact(-0.23)           end),
    awful.key({ settings.modkey, "Control" }, "k",              function() awful.client.incwfact(0.23)            end),
    awful.key({ settings.modkey, "Control" }, "l",              function() awful.tag.incmwfact(-0.025)            end),
    awful.key({ settings.modkey, "Shift"   }, "h",              function() awful.client.swap.bydirection("left")  end),
    awful.key({ settings.modkey, "Shift"   }, "j",              function() awful.client.swap.bydirection("down")  end),
    awful.key({ settings.modkey, "Shift"   }, "k",              function() awful.client.swap.bydirection("up")    end),
    awful.key({ settings.modkey, "Shift"   }, "l",              function() awful.client.swap.bydirection("right") end),
    -- Mod1 is Alt
    awful.key({ settings.modkey, "Mod1"    }, "j",              function() awful.screen.focus_relative(-1)        end),
    awful.key({ settings.modkey, "Mod1"    }, "k",              function() awful.screen.focus_relative(1)         end),
    awful.key({ settings.modkey            }, "space",          function() awful.layout.inc(settings.layouts, 1)  end),
    awful.key({ settings.modkey, "Shift"   }, "space",          function() awful.layout.inc(settings.layouts, -1) end),
    awful.key({ settings.modkey            }, "r",              function() promptbox[mouse.screen]:run()          end)
)

local clientkeys = awful.util.table.join(
    awful.key({ settings.modkey            }, "c",     function(c) c:kill() end),
    awful.key({ settings.modkey, "Control" }, "space", awful.client.floating.toggle),
    awful.key({ settings.modkey, "Shift"   }, "f",     function(c) c.fullscreen = not c.fullscreen end),
    awful.key({ settings.modkey            }, "m",     function(c)
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
        awful.key({ settings.modkey }, "#" .. i + 9, function()
            local screen = mouse.screen
            if tags[screen][i] then
                awful.tag.viewonly(tags[screen][i])
            end
        end),
        awful.key({ settings.modkey, "Control" }, "#" .. i + 9, function()
            local screen = mouse.screen
            if tags[screen][i] then
                awful.tag.viewtoggle(tags[screen][i])
            end
        end),
        awful.key({ settings.modkey, "Shift" }, "#" .. i + 9, function()
            if client.focus and tags[client.focus.screen][i] then
                awful.client.movetotag(tags[client.focus.screen][i])
            end
        end),
        awful.key({ settings.modkey, "Control", "Shift" }, "#" .. i + 9, function()
            if client.focus and tags[client.focus.screen][i] then
                awful.client.toggletag(tags[client.focus.screen][i])
            end
        end)
    )
end

function nth_next_tag (n)
    return awful.util.cycle(#tags[client.focus.screen], awful.tag.getidx(awful.tag.selected(client.focus.screen)) + n)
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function(c) client.focus = c; c:raise() end),
    awful.button({ settings.modkey }, 1, function(c)
        c:raise()
        awful.mouse.client.move(c)
    end),
    awful.button({ settings.modkey }, 3, function(c)
        c:raise()
        awful.mouse.client.resize(c)
    end),
    awful.button({ settings.modkey }, 4, function()
        if client.focus and tags[client.focus.screen][nth_next_tag(1)] then
            awful.client.movetotag(tags[client.focus.screen][nth_next_tag(1)])
        end
        awful.tag.viewnext()
    end),
    awful.button({ settings.modkey }, 5, function()
        if client.focus and tags[client.focus.screen][nth_next_tag(1)] then
            awful.client.movetotag(tags[client.focus.screen][nth_next_tag(-1)])
        end
        awful.tag.viewprev()
    end)
)

mpd:append_global_keys()
root.keys(globalkeys)
--- }}}

-- {{{ Rules
awful.rules.rules =
{
    {
        rule = { },
        properties =
        {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = true,
            keys = clientkeys,
            buttons = clientbuttons,
            size_hints_honor = false
        }
    },
    {
        rule_any =
        {
            class =
            {
                "Ahoviewer",
                "Ampv",
                "Anidbmini",
                "Awf-gtk2",
                "Blender",
                "Calc",
                "Civ5XP",
                "csgo_linux",
                "dota_linux",
                "dota2",
                "Gimp",
                "mahjong",
                "mpv",
                "Plugin-container",
                "scrot",
                "Skype",
                "starbound",
                "Steam",
                "Thunderbird",
                "Terraria.bin.x86_64",
                "Torchlight.bin.x86_64",
                "Torchlight2.bin.x86_64",
                "Wine",
                ".*\.exe",
            },
            name =
            {
                "Kingdom Rush HD",
            }
        },
        properties = { floating = true }
    },
    {
        rule_any =
        {
            class =
            {
                "csgo_linux",
                "Civ5XP",
                "dota_linux",
                "dota2",
                "Plugin-container",
                "scrot",
                "starbound",
                "Steam",
                "Terraria.bin.x86_64",
                "Torchlight.bin.x86_64",
                "Torchlight2.bin.x86_64",
                "Wine",
                ".*\.exe",
            },
            name =
            {
                "Kingdom Rush HD",
            }
        },
        properties = { border_width = 0 }
    },
    {
        rule_any =
        {
            class =
            {
                "csgo_linux",
                "Civ5XP",
                "dota_linux",
                "dota2",
                "starbound",
                "Terraria.bin.x86_64",
                "Torchlight.bin.x86_64",
                "Torchlight2.bin.x86_64",
            },
            name =
            {
                "Kingdom Rush HD",
            }
        },
        properties = { x = 0, y = 0, screen = 1 }
    },
    { rule = { instance = "sun-awt-X11-XWindowPeer" }, properties = { border_width = 0, floating = true, focusable = false, ontop = true, skip_taskbar = true } },
    { rule = { class = "Thunar", name = "File Operation Progress" }, properties = { floating = true } },
    { rule = { class = "Firefox" }, except = { instance = "Navigator" }, properties = { floating = true } },
    { rule = { class = "VirtualBox", name = "Windows 7.*VirtualBox" }, properties = { border_width = 0, floating = true, skip_taskbar = true } },

}
-- }}}

-- {{{ Signals

-- {{{ My under_mouse that is screen aware
local capi =
{
    screen = screen,
    mouse = mouse,
    client = client
}

local function get_area(c)
    local geometry = c:geometry()
    local border = c.border_width or 0
    geometry.width = geometry.width + 2 * border
    geometry.height = geometry.height + 2 * border
    return geometry
end

function under_mouse(c)
    local c = c or capi.client.focus
    local c_geometry = get_area(c)
    local m_coords = capi.mouse.coords()
    local screen = c.screen or awful.screen.getbycoord(geometry.x, geometry.y)
    local screen_geometry = capi.screen[screen].workarea
    return c:geometry({ x = math.max(screen_geometry.x, m_coords.x - c_geometry.width / 2),
                        y = math.max(screen_geometry.y, m_coords.y - c_geometry.height / 2) })
end
-- }}}

client.connect_signal("manage", function(c)
    if not awesome.startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        awful.client.setslave(c)
        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            under_mouse(c)
            awful.placement.no_offscreen(c)
        end
    elseif not c.size_hints.user_position and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count change
        awful.placement.no_offscreen(c)
    end
end)

-- Enable sloppy focus
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
