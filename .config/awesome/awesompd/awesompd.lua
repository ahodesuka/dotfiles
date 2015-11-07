---------------------------------------------------------------------------
-- @author Alexander Yakushev <yakushev.alex@gmail.com>
-- @copyright 2010-2013 Alexander Yakushev
-- @release v1.2.4
---------------------------------------------------------------------------

local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local format = string.format

local module_path = (...):match ("(.+/)[^/]+$") or ""

local awesompd = { }

-- Function for checking icons and modules. Checks if a file exists,
-- and if it does, returns the path to file, nil otherwise.
function awesompd.try_load(file)
    if awful.util.file_readable(file) then
        return file
    end
end

-- Function for loading modules.
function awesompd.try_require(module)
    if awesompd.try_load(awful.util.getdir("config") .. "/"..
                         module_path .. module .. ".lua") then
        return require(module_path .. module)
    else
        return require(module)
    end
end

local utf8 = awesompd.try_require("utf8")

-- Constants
awesompd.PLAYING = "Playing"
awesompd.PAUSED = "Paused"
awesompd.STOPPED = "MPD stopped"
awesompd.DISCONNECTED = "Disconnected"

awesompd.MOUSE_LEFT = 1
awesompd.MOUSE_MIDDLE = 2
awesompd.MOUSE_RIGHT = 3
awesompd.MOUSE_SCROLL_UP = 4
awesompd.MOUSE_SCROLL_DOWN = 5

-- {{{  Current track variables and functions

-- Returns a string for the given track to be displayed in the widget
-- and notification.
function awesompd.get_display_name(track)
    if track.display_name then
        return track.display_name
    elseif track.artist_name and track.track_name then
        return track.artist_name .. " - " .. track.name
    end
end

-- Returns true if the current status is either PLAYING or PAUSED
function awesompd:playing_or_paused()
    return self.status == awesompd.PLAYING or self.status == awesompd.PAUSED
end
-- }}}

-- {{{  Helper functions

-- Just like awful.util.pread, but takes an argument how to read like
-- "*line" or "*all".
function awesompd.pread(com, mode)
    local f = io.popen(com, 'r')
    local result = nil
    if f then
        result = f:read(mode)
        f:close()
    end
    return result
end

-- Slightly modified function awful.util.table.join.
function awesompd.ajoin(buttons)
    local result = { }
    for i = 1, #buttons do
        if buttons[i] then
            for k, v in pairs(buttons[i]) do
                if type(k) == "number" then
                    table.insert(result, v)
                else
                    result[k] = v
                end
            end
        end
    end
    return result
end

-- Splits a given string with linebreaks into an array.
function awesompd.split(s)
    local l = { n = 0 }
    if s == "" then
        return l
    end
    s = s .. "\n"
    local f = function(s)
        l.n = l.n + 1
        l[l.n] = s
    end
    local p = "%s*(.-)%s*\n%s*"
    s = string.gsub(s, p, f)
    return l
end

local function to_seconds(minsec)
    local min, sec = minsec:match("(%d+):(%d+)")
    return tonumber(min) * 60 + tonumber(sec)
end

local function to_minsec(seconds)
    local min = math.floor(seconds / 60)
    local sec = seconds % 60
    return string.format("%s:%s%s", min, (sec < 10) and "0" or "", sec)
end

-- Returns the given string if it is not nil or non-empty, otherwise
-- returns nil.
local function non_empty(s)
    if s and s ~= "" then
        return s
    end
end
-- }}}

-- Icons

function awesompd.load_icons(path)
    if not path then return end
    awesompd.ICONS = { }
    awesompd.ICONS.PLAY = awesompd.try_load(path .. "/play_icon.png")
    awesompd.ICONS.PAUSE = awesompd.try_load(path .. "/pause_icon.png")
    awesompd.ICONS.PLAY_PAUSE = awesompd.try_load(path .. "/play_pause_icon.png")
    awesompd.ICONS.STOP = awesompd.try_load(path .. "/stop_icon.png")
    awesompd.ICONS.NEXT = awesompd.try_load(path .. "/next_icon.png")
    awesompd.ICONS.PREV = awesompd.try_load(path .. "/prev_icon.png")
    awesompd.ICONS.CHECK = awesompd.try_load(path .. "/check_icon.png")
    awesompd.ICONS.RADIO = awesompd.try_load(path .. "/radio_icon.png")
    awesompd.ICONS.DEFAULT_ALBUM_COVER =  awesompd.try_load(path .. "/default_album_cover.png")
    awesompd.ICONS.PLAY_BTN = awesompd.try_load(path .. "/play_btn.png")
    awesompd.ICONS.PAUSE_BTN = awesompd.try_load(path .. "/pause_btn.png")
    awesompd.ICONS.STOP_BTN = awesompd.try_load(path .. "/stop_btn.png")
    awesompd.ICONS.NEXT_BTN = awesompd.try_load(path .. "/next_btn.png")
    awesompd.ICONS.PREV_BTN = awesompd.try_load(path .. "/prev_btn.png")
end

-- Function that returns a new awesompd object.
function awesompd:create(args)
    -- Initialization
    args = args or { }
    local instance = { }
    setmetatable(instance, self)
    self.__index = self
    -- Settings
    instance.servers          = args.servers or { { server = "localhost", port = 6600 } }
    instance.scrolling        = args.scrolling == nil and true or args.scrolling
    instance.output_size      = args.output_size or 30
    instance.max_width        = args.max_width -- nil here means no max width
    instance.path_to_icons    = args.path_to_icons
    instance.ldecorator       = args.ldecorator or " "
    instance.rdecorator       = args.rdecorator or " "
    instance.show_album_cover = args.show_album_cover == nil and true or args.show_album_cover
    instance.mpd_config       = args.mpd_config

    -- Initial values
    instance.widget = wibox.layout.fixed.horizontal()
    instance.current_server = 1
    instance.scroll_pos = 1
    instance.text = ""
    instance.to_notify = false
    instance.album_cover = nil
    instance.current_track = { }
    instance.recreate_menu = true
    instance.recreate_playback = true
    instance.recreate_list = true
    instance.recreate_servers = true
    instance.recreate_options = true
    instance.current_number = 0
    instance.menu_shown = false
    instance.state_volume = "NaN"
    instance.state_repeat = "NaN"
    instance.state_random = "NaN"
    instance.state_single = "NaN"
    instance.state_consume = "NaN"
    instance.track_update_time = 0
    instance.track_passed = 0
    instance.track_duration = 0
    instance.calc_track_passed = 0
    instance.calc_track_progress = 0

    instance.load_icons(instance.path_to_icons)
    instance:create_osd(args.osd)

    -- Cleanup mpc idleloop call on exit/restart
    awesome.connect_signal("exit", function()
        if instance.idle_pid then
            awful.util.spawn("kill " .. instance.idle_pid)
        end
    end)

    -- Widget configuration
    instance.widget:connect_signal("mouse::enter", function(c)
        --instance:update_track()
        instance.osd.show()
    end)
    instance.widget:connect_signal("mouse::leave", function(c)
        instance.osd.hide(2)
    end)

    instance:run()

    return instance
end

function awesompd:create_osd(args)
    self.osd           = { }
    local args         = args or { }
    local scr          = args.screen or 1
    local scrgeom      = screen[scr].geometry
    local cover_size   = args.cover_size or 90
    local width        = cover_size + (args.width or 230)
    local height       = cover_size + 10
    local x            = args.x or 20
    local y            = args.y or -20
    local font         = args.font or beautiful.font
    local alt_fg_color = args.alt_fg_color or "#aaaaaa"
    local hovering     = false
    local hide_timer   = nil

    if x >= 0 then
        x = scrgeom.x + x
    else
        x = scrgeom.x + scrgeom.width + x - width
    end

    if y >= 0 then
        y = scrgeom.y + y
    else
        y = scrgeom.y + scrgeom.height + y - height
    end

    local with_margins = wibox.layout.margin

    local cover_img = wibox.widget.imagebox()
    local top_layout = wibox.layout.fixed.horizontal()
    local ver_layout = wibox.layout.fixed.vertical()
    local buttons_layout = wibox.layout.fixed.horizontal()
    local bottom_layout = wibox.layout.align.horizontal()
    top_layout:add(with_margins(cover_img, 5, 10, 5, 5))
    top_layout:add(ver_layout)

    local track_text = wibox.widget.textbox()
    local album_text = wibox.widget.textbox()

    -- This height would need to be adjusted for larger fonts
    local track = wibox.layout.constraint(track_text, "max", width, 18)
    local album = wibox.layout.constraint(album_text, "max", width, 18)

    track_text:set_ellipsize("middle")
    album_text:set_ellipsize("middle")

    local progress_bar = awful.widget.progressbar({ height = 2, border_width = 0 })
    progress_bar:set_background_color(args.bar_bg_color or "#444444")
    progress_bar:set_color(args.bar_fg_color or "#aaaaaa")
    progress_bar:set_max_value(100)

    local state_text = wibox.widget.textbox()
    state_text:set_align("right")

    -- Make the album cover 1:1 aspect ratio
    cover_img.fit = function() return cover_size, cover_size end
    -- Force the width
    bottom_layout.fit = function() return width, 16 end

    local v_margin = 6
    ver_layout:add(with_margins(track, 0, 10, v_margin + 12, 0))
    ver_layout:add(with_margins(album, 0, 10, 3, 0))
    ver_layout:add(with_margins(progress_bar, 0, 10, v_margin, 0))
    ver_layout:add(with_margins(bottom_layout, 0, 0, v_margin, 0))
    ver_layout:add(with_margins(state_text, 0, 16, 0, 0))

    local status_text = wibox.widget.textbox()
    status_text:set_align("right")

    local function make_button(image, callback)
        local box = wibox.widget.imagebox(image, false)
        box:buttons(awful.util.table.join(awful.button({ }, 1, callback)))
        return box
    end

    buttons_layout:add(make_button(self.ICONS.PREV_BTN, self:command_prev_track()))
    local pp_button = make_button(self.ICONS.PLAY_BTN, self:command_playpause())
    buttons_layout:add(pp_button)
    buttons_layout:add(make_button(self.ICONS.STOP_BTN, self:command_stop()))
    buttons_layout:add(make_button(self.ICONS.NEXT_BTN, self:command_next_track()))

    bottom_layout:set_left(buttons_layout)
    bottom_layout:set_right(with_margins(status_text, 0, 16, -2, 0))

    self.osd.wb = wibox({ bg = args.color or beautiful.bg_normal,
                          border_color = args.border_color or beautiful.menu_border_color,
                          border_width = 1,
                          height = height,
                          width = width,
                          x = x,
                          y = y,
                          screen = scr,
                          visible = false,
                          ontop = true,
                        })
    self.osd.wb:set_widget(top_layout)

    self.osd.wb:connect_signal("mouse::enter", function(c)
        self.osd.show()
    end)
    self.osd.wb:connect_signal("mouse::leave", function(c)
        self.osd.hide(2)
    end)

    -- Hide the OSD after n seconds
    function self.osd.hide(n)
        hovering = false
        n = n or 0
        if n > 0 then
            hide_timer = timer({ timeout = n })
            hide_timer:connect_signal("timeout", function()
                hide_timer:stop()
                self.osd.wb.visible = false
            end)
            hide_timer:start()
        else
            self.osd.wb.visible = false
        end
    end

    -- Show OSD for n seconds
    -- if n is nil then it's shown until hide is called
    function self.osd.show(n)
        if self:playing_or_paused() and not (hovering and n) then
            hovering = n == nil
            if hide_timer then
                hide_timer:stop()
            end
            self.osd.wb.visible = true
            if n then
                self.osd.hide(n)
            end
        end
    end

    function self.osd.update()
        local title = self.current_track.display_name
        local album = self.current_track.album
        local date = self.current_track.date

        if non_empty(album) and non_empty(date) then
            date = " (" .. date .. ")"
        end

        track_text:set_markup(
            string.format("<span font='%s'>%s</span>", font,
                          awesompd.protect_string(title)))
        album_text:set_markup(
            string.format("<span font='%s'>%s%s</span>", font,
                          awesompd.protect_strings(album, date)))
        status_text:set_markup(
            string.format("<span fgcolor='%s' font='%s'>%s</span> ", alt_fg_color, font,
                          awesompd.protect_string(self.track_n_count)) ..
            string.format("<span font='%s'>%s/%s</span>", font,
                          awesompd.protect_strings(to_minsec(self.calc_track_passed),
                                                   to_minsec(self.track_duration))))
        cover_img:set_image(self.current_track.album_cover)
        progress_bar:set_value(self.calc_track_progress)
        if self.status == awesompd.PLAYING then
            pp_button:set_image(self.ICONS.PAUSE_BTN)
        elseif self.status == awesompd.PAUSED then
            pp_button:set_image(self.ICONS.PLAY_BTN)
        end

        local fmt, s = "<span fgcolor='%s'>%sVolume: %s</span>", ""
        if self.state_repeat == "on" then
            s = s .. "r"
        end
        if self.state_random == "on" then
            s = s .. "z"
        end
        if self.state_single == "on" then
            s = s .. "s"
        end
        if self.state_consume == "on" then
            s = s .. "c"
        end
        if s ~= "" then
            s = "[" .. s .. "] "
        end
        state_text:set_markup(string.format(fmt, alt_fg_color, s, self.state_volume))
    end

    self.osd.hide()
end

-- Registers timers for the widget
function awesompd:run()
    self.text_widget = wibox.widget.textbox()
    if self.widget_icon then
        self.icon_widget = wibox.widget.imagebox()
        self.icon_widget:set_image(self.widget_icon)
        self.widget:add(self.icon_widget)
    end
    self.widget:add(wibox.layout.constraint(self.text_widget, "max", self.max_width, nil))

    self.update_timer = timer({ timeout = 0.5 })
    self.update_timer:connect_signal("timeout", function()
        self:start_idleloop()
        self:update_widget()
    end)
    self.update_timer:start()

    self:check_playlists()
    self:start_idleloop()
end

-- Function that registers buttons on the widget.
function awesompd:register_buttons(buttons)
    widget_buttons = { }
    self.global_bindings = { }
    for b = 1, #buttons do
        if type(buttons[b][1]) == "string" then
            mods = { buttons[b][1] }
        else
            mods = buttons[b][1]
        end
        if type(buttons[b][2]) == "number" then
            -- This is a mousebinding, bind it to the widget
            table.insert(widget_buttons,
                         awful.button(mods, buttons[b][2], buttons[b][3]))
        else
            -- This is a global keybinding, remember it for later usage in append_global_keys
            table.insert(self.global_bindings, awful.key(mods, buttons[b][2], buttons[b][3]))
        end
    end
    self.widget:buttons(self.ajoin(widget_buttons))
end

-- Takes the current table with keybindings and adds widget's own
-- global keybindings that were specified in register_buttons.
-- If keytable is not specified, then adds bindings to default
-- globalkeys table. If specified, then adds bindings to keytable and
-- returns it.
function awesompd:append_global_keys(keytable)
    if keytable then
        for i = 1, #self.global_bindings do
            keytable = awful.util.table.join(keytable, self.global_bindings[i])
        end
        return keytable
    else
        for i = 1, #self.global_bindings do
            globalkeys = awful.util.table.join(globalkeys, self.global_bindings[i])
        end
    end
end

-- {{{ Group of mpc command functions

-- Returns a mpc command with all necessary parameters. Boolean
-- human_readable argument configures if the command special
-- formatting of the output (to be later used in parsing) should not
-- be used.
function awesompd:mpcquery(human_readable)
    local result =
    "mpc -h " .. self.servers[self.current_server].server ..
    " -p " .. self.servers[self.current_server].port .. " "
    if human_readable then
        return result
    else
        return result .. " -f '%file%-<>-%name%-<>-%title%-<>-%artist%-<>-%album%-<>-%date%' "
    end
end

-- Takes a command to mpc and a hook that is provided with awesompd
-- instance and the result of command execution.
function awesompd:command(com, hook)
    local file = io.popen(self:mpcquery() .. com)
    if hook then
        hook(self, file)
    end
    file:close()
end

-- Takes a command to mpc and read mode and returns the result.
function awesompd:command_read(com, mode)
    mode = mode or "*line"
    self:command(com, function(_, f)
        result = f:read(mode)
    end)
    return result
end

function awesompd:command_playpause()
    return function()
        self:command("toggle", self.update_track)
    end
end

function awesompd:command_next_track()
    return function()
        self:command("next", self.update_track)
    end
end

function awesompd:command_prev_track()
    return function()
        self:command("seek 0")
        self:command("prev", self.update_track)
    end
end

function awesompd:command_stop()
    return function()
        self:command("stop", self.update_track)
    end
end

function awesompd:command_play_specific(n)
    return function()
        self:command("play " .. n, self.update_track)
    end
end

function awesompd:command_volume_up()
    return function()
        self:command("volume +5", self.update_track)
    end
end

function awesompd:command_volume_down()
    return function()
        self:command("volume -5", self.update_track)
    end
end

function awesompd:command_load_playlist(name)
    return function()
        self:command("load '" .. name .. "'", function()
            self.recreate_menu = true
        end)
    end
end

function awesompd:command_replace_playlist(name)
    return function()
        self:command("clear")
        self:command("load '" .. name .. "'")
        self:command("play 1", self.update_track)
    end
end

function awesompd:command_clear_playlist()
    return function()
        self:command("clear", self.update_track)
        self.recreate_list = true
        self.recreate_menu = true
    end
end

--- Change to the previous server.
function awesompd:command_previous_server()
    return function()
        servers = table.getn(self.servers)
        if servers == 1 or servers == nil then
            return
        else
            if self.current_server > 1 then
                self:change_server(self.current_server - 1)
            else
                self:change_server(servers)
            end
        end
    end
end

--- Change to the previous server.
function awesompd:command_next_server()
    return function()
        servers = table.getn(self.servers)
        if servers == 1 or servers == nil then
            return
        else
            if self.current_server < servers then
                self:change_server(self.current_server + 1)
            else
                self:change_server(1)
            end
        end
    end
end

-- }}} End of mpc command functions

-- {{{  Menu generation functions

function awesompd:command_show_menu()
    return function()
        self.osd.hide()
        if self.recreate_menu then
            local new_menu = { }
            if self.main_menu ~= nil then
                self.main_menu:hide()
            end
            if self.status ~= awesompd.DISCONNECTED then
                self:check_list()
                self:check_playlists()
                new_menu = {
                    { "Playback", self:menu_playback() },
                    { "Options", self:menu_options() },
                    { "List", self:menu_list() },
                    { "Playlists", self:menu_playlists() }
                }
            end
            table.insert(new_menu, { "Servers", self:menu_servers() })
            self.main_menu = awful.menu({ items = new_menu, theme = { width = 180 } })
            self.recreate_menu = false
        end
        self.main_menu:toggle()
    end
end

-- Returns an icon for a checkbox menu item if it is checked, nil
-- otherwise.
function awesompd:menu_item_toggle(checked)
    return checked and self.ICONS.CHECK or nil
end

-- Returns an icon for a radiobox menu item if it is selected, nil
-- otherwise.
function awesompd:menu_item_radio(selected)
    return selected and self.ICONS.RADIO or nil
end

-- Returns the playback menu. Menu contains of:
-- Play/Pause - always
-- Previous - if the current track is not the first
-- in the list and playback is not stopped
-- Next - if the current track is not the last
-- in the list and playback is not stopped
-- Stop - if the playback is not stopped
-- Clear playlist - always
function awesompd:menu_playback()
    if self.recreate_playback then
        local new_menu = { }
        table.insert(new_menu, { "Play/Pause",
                     self:command_playpause(),
                     self.ICONS.PLAY_PAUSE })
        if self:playing_or_paused() then
            if self.list_array and self.list_array[self.current_number-1] then
                table.insert(new_menu,
                             { "Prev: " ..
                                 awesompd.protect_string(self.list_array[self.current_number - 1],
                                                         true),
                                 self:command_prev_track(), self.ICONS.PREV })
            end
            if self.list_array and self.current_number ~= #self.list_array then
                table.insert(new_menu,
                             { "Next: " ..
                                 awesompd.protect_string(self.list_array[self.current_number + 1],
                                                         true),
                                 self:command_next_track(), self.ICONS.NEXT })
            end
            table.insert(new_menu, { "Stop", self:command_stop(), self.ICONS.STOP })
            table.insert(new_menu, { "", nil })
        end
        table.insert(new_menu, { "Clear playlist", self:command_clear_playlist() })
        self.recreate_playback = false
        playback_menu = new_menu
    end
    return playback_menu
end

-- Returns the current playlist menu. Menu consists of all elements in the playlist.
function awesompd:menu_list()
    if self.recreate_list then
        local new_menu = { }
        if self.list_array then
            local total_count = #self.list_array
            local start_num = (self.current_number - 15 > 0) and self.current_number - 15 or 1
            local end_num = (self.current_number + 15 < total_count ) and self.current_number + 15 or total_count
            for i = start_num, end_num do
                table.insert(new_menu, {
                             self.list_array[i],
                             self:command_play_specific(i),
                             self.current_number == i and
                             (self.status == self.PLAYING and self.ICONS.PLAY or self.ICONS.PAUSE)
                             or nil
                         })
            end
        end
        self.recreate_list = false
        self.list_menu = new_menu
    end
    return self.list_menu
end

-- Returns the playlists menu. Menu consists of all files in the playlist folder.
function awesompd:menu_playlists()
    if self.recreate_playlists then
        local new_menu = { }
        if #self.playlists_array > 0 then
            for i = 1, #self.playlists_array do
                local submenu = { }
                submenu[1] = { "Add to current", self:command_load_playlist(self.playlists_array[i]) }
                submenu[2] = { "Replace current", self:command_replace_playlist(self.playlists_array[i]) }
                new_menu[i] = { self.playlists_array[i], submenu }
            end
            table.insert(new_menu, { "", "" }) -- This is a separator
        end
        table.insert(new_menu, { "Refresh", function() self:check_playlists() end })
        self.recreate_playlists = false
        self.playlists_menu = new_menu
    end
    return self.playlists_menu
end

-- Returns the server menu. Menu consists of all servers specified by user during initialization.
function awesompd:menu_servers()
    if self.recreate_servers then
        local new_menu = { }
        for i = 1, #self.servers do
            table.insert(new_menu, {
                         "Server: " .. self.servers[i].server ..
                         ", port: " .. self.servers[i].port,
                         function() self:change_server(i) end,
                         self:menu_item_radio(i == self.current_server)
                     })
        end
        self.servers_menu = new_menu
    end
    return self.servers_menu
end

-- Returns the options menu. Menu works like checkboxes for it's elements.
function awesompd:menu_options()
    if self.recreate_options then
        local new_menu = {
            { "Repeat", self:menu_toggle_repeat(),
            self:menu_item_toggle(self.state_repeat == "on") },
            { "Random", self:menu_toggle_random(),
            self:menu_item_toggle(self.state_random == "on") },
            { "Single", self:menu_toggle_single(),
            self:menu_item_toggle(self.state_single == "on") },
            { "Consume", self:menu_toggle_consume(),
            self:menu_item_toggle(self.state_consume == "on") }
        }
        self.options_menu = new_menu
        self.recreate_options = false
    end
    return self.options_menu
end

function awesompd:menu_toggle_random()
    return function()
        self:command("random", self.update_track)
    end
end

function awesompd:menu_toggle_repeat()
    return function()
        self:command("repeat", self.update_track)
    end
end

function awesompd:menu_toggle_single()
    return function()
        self:command("single", self.update_track)
    end
end

function awesompd:menu_toggle_consume()
    return function()
        self:command("consume", self.update_track)
    end
end

-- Checks if the current playlist has changed after the last check.
function awesompd:check_list()
    local bus = io.popen(self:mpcquery(true) .. "playlist")
    local info = bus:read("*all")
    bus:close()
    if info ~= self.list_line then
        self.list_line = info
        if string.len(info) > 0 then
            self.list_array = self.split(string.sub(info, 1, string.len(info)))
        else
            self.list_array = { }
        end
        self.recreate_menu = true
        self.recreate_list = true
    end
end

-- Checks if the collection of playlists changed after the last check.
function awesompd:check_playlists()
    local bus = io.popen(self:mpcquery(true) .. "lsplaylists")
    local info = bus:read("*all")
    bus:close()
    if info ~= self.playlists_line then
        self.playlists_line = info
        if string.len(info) > 0 then
            self.playlists_array = self.split(info)
        else
            self.playlists_array = { }
        end
        self.recreate_menu = true
        self.recreate_playlists = true
    end
end

-- Changes the current server to the specified one.
function awesompd:change_server(server_number)
    self.current_server = server_number
    self.osd.hide()
    self.recreate_menu = true
    self.recreate_playback = true
    self.recreate_list = true
    self.recreate_playlists = true
    self.recreate_servers = true
    self:update_track()
end

-- }}}  End of menu generation functions

function awesompd:wrap_output(text)
    return format("%s%s%s",
                  (text == "" and "" or self.ldecorator), awesompd.protect_string(text),
                  (text == "" and "" or self.rdecorator))
end

-- This function actually sets the text on the widget.
function awesompd:set_text(text)
    self.text_widget:set_markup(self:wrap_output(text))
end

function awesompd.find_pattern(text, pattern, start)
    return utf8.sub(text, string.find(text, pattern, start))
end

-- Scroll the given text by the current number of symbols.
function awesompd:scroll_text(text)
    local result = text
    if self.scrolling then
        if self.output_size < utf8.len(text) then
            text = text .. " - "
            if self.scroll_pos + self.output_size - 1 > utf8.len(text) then
                result = utf8.sub(text, self.scroll_pos)
                result = result .. utf8.sub(text, 1, self.scroll_pos + self.output_size - 1 - utf8.len(text))
                self.scroll_pos = self.scroll_pos + 1
                if self.scroll_pos > utf8.len(text) then
                    self.scroll_pos = 1
                end
            else
                result = utf8.sub(text, self.scroll_pos, self.scroll_pos + self.output_size - 1)
                self.scroll_pos = self.scroll_pos + 1
            end
        end
    end
    return result
end

function awesompd:recalc_progress()
    if self.status == awesompd.PLAYING then
        local diff = os.time() - self.track_update_time
        local passed = math.min(self.track_passed + diff, self.track_duration)
        local prog = math.floor(passed / self.track_duration * 100 + 0.5)
        self.calc_track_passed = passed
        self.calc_track_progress = prog
    elseif self.status == awesompd.PAUSED then
        self.calc_track_passed = self.track_passed
        self.calc_track_progress = self.track_progress
    end
end

-- This function is called every second.
function awesompd:update_widget()
    self:set_text(self:scroll_text(self.text))
    if self:playing_or_paused() then
        self:recalc_progress()
        if self.osd.wb.visible then
            self.osd.update()
        end
        self:check_notify()
    end
end

-- This function is called by update_track each time content of
-- the widget must be changed.
function awesompd:update_widget_text()
    if self:playing_or_paused() then
        self.text = self.get_display_name(self.current_track)
    else
        self.text = self.status
    end
    self:update_widget()
end

-- Checks if notification should be shown and shows if positive.
function awesompd:check_notify()
    if self.to_notify then
        self.osd.update()
        self.osd.show(5)
        self.to_notify = false
    end
end

function awesompd:update_track(file)
    local file_exists = (file ~= nil)
    if not file_exists then
        file = io.popen(self:mpcquery())
    end
    self.track_update_time = os.time()
    local track_line = file:read("*line")
    local status_line = file:read("*line")
    local options_line = file:read("*line")
    if not file_exists then
        file:close()
    end

    if not track_line or string.len(track_line) == 0 then
        if self.status ~= awesompd.DISCONNECTED then
            self.recreate_menu = true
            self.status = awesompd.DISCONNECTED
            self.current_track = { }
            self.osd.hide()
        end
    else
        if self.status == awesompd.DISCONNECTED then
            self.recreate_menu = true
            self.osd.hide()
        end
        if string.find(track_line,"volume:") or string.find(track_line,"Updating DB") then
            if self.status ~= awesompd.STOPPED then
                self.status = awesompd.STOPPED
                self.current_number = 0
                self.recreate_menu = true
                self.recreate_playback = true
                self.recreate_list = true
                self.album_cover = nil
                self.current_track = { }
            end
            self:update_state(track_line)
            self.osd.hide()
        else
            self:update_state(options_line)
            local _, _, new_file, station, title, artist, album, date =
            string.find(track_line, "(.*)%-<>%-(.*)%-<>%-(.*)%-<>%-(.*)%-<>%-(.*)%-<>%-(.*)")
            local display_name, force_update = artist .. " - " .. title, false
            -- The following code checks if the current track is an
            -- Internet link. Internet radios change tracks, but the
            -- current file stays the same, so we should manually compare
            -- its title.
            if string.match(new_file, "http://") then
                album = non_empty(station) or ""
                display_name = non_empty(title) or new_file
                if display_name ~= self.current_track.display_name then
                    force_update = true
                end
            end
            if new_file ~= self.current_track.unique_name or force_update then
                self.current_track = { display_name = display_name,
                                       album = album,
                                       date = date
                                   }
                self.current_track.unique_name = new_file
                if self.show_album_cover then
                    self.current_track.album_cover = self:get_cover(new_file)
                end
                self.to_notify = true
                self.recreate_menu = true
                self.recreate_playback = true
                self.recreate_list = true
                self.current_number = tonumber(self.find_pattern(status_line,"%d+"))
            end
            local new_status = awesompd.PLAYING
            local status, track_n_count, time_passed, track_duration, track_progress =
            status_line:match("%[(%w+)%]%s+(%#%d+/%d+)%s+(%d+:%d+)/(%d+:%d+)%s+%((%d+)%%%)")
            self.track_n_count = track_n_count
            self.track_passed = to_seconds(time_passed)
            self.track_duration = to_seconds(track_duration)
            self.track_progress = tonumber(track_progress)
            if status:match("paused") then
                new_status = awesompd.PAUSED
            end
            if new_status ~= self.status then
                self.to_notify = true
                self.recreate_list = true
                self.status = new_status
            end
        end
    end
    self:update_widget_text()
end

function awesompd:start_idleloop()
    if not self.idle_pid then
        local cmd = self:mpcquery(true) .. "idleloop mixer options player playlist"
        self.idle_pid = awful.spawn.with_line_callback(cmd, function(e)
            self:update_track()
            if e == "options" or e == "mixer" then
                self.osd.show(5)
            end
        end,
        -- stderr, loop will end
        function(e)
            self:update_track()
            self.idle_pid = nil
        end)
        self:update_track()
    end
end

function awesompd:update_state(state_string)
    self.state_volume = self.find_pattern(state_string,"%d+%%")
    if string.find(state_string,"repeat: on") then
        self.state_repeat = self:check_set_state(self.state_repeat, "on")
    else
        self.state_repeat = self:check_set_state(self.state_repeat, "off")
    end
    if string.find(state_string,"random: on") then
        self.state_random = self:check_set_state(self.state_random, "on")
    else
        self.state_random = self:check_set_state(self.state_random, "off")
    end
    if string.find(state_string,"single: on") then
        self.state_single = self:check_set_state(self.state_single, "on")
    else
        self.state_single = self:check_set_state(self.state_single, "off")
    end
    if string.find(state_string,"consume: on") then
        self.state_consume = self:check_set_state(self.state_consume, "on")
    else
        self.state_consume = self:check_set_state(self.state_consume, "off")
    end
end

function awesompd:check_set_state(statevar, val)
    if statevar ~= val then
        self.recreate_menu = true
        self.recreate_options = true
    end
    return val
end

-- Replaces control characters with escaped ones.
-- for_menu - defines if the special escable table for menus should be
-- used.
function awesompd.protect_string(str, for_menu)
    return awful.util.escape(str)
end

function awesompd.protect_strings(...)
    local str = { }
    for i, s in ipairs(arg) do
        str[i] = awful.util.escape(s)
    end
    return unpack(str)
end

function awesompd:get_cover(track)
    return self:try_get_local_cover(track) or self.ICONS.DEFAULT_ALBUM_COVER
end

-- Tries to find an album cover for the track that is currently
-- playing.
function awesompd:try_get_local_cover(current_file)
    if self.mpd_config then
        local result
        -- First find the music directory in MPD configuration file
        local _, _, music_folder = string.find(
            self.pread('cat ' .. self.mpd_config .. ' | grep -v "#" | grep music_directory', "*line"),
            'music_directory%s+"(.+)"')
        music_folder = music_folder .. "/"

        -- If the music_folder is specified with ~ at the beginning,
        -- replace it with user home directory
        if string.sub(music_folder, 1, 1) == "~" then
            local user_folder = self.pread("echo ~", "*line")
            music_folder = user_folder .. string.sub(music_folder, 2)
        end

        -- Get the path to the file currently playing.
        local _, _, current_file_folder = string.find(current_file, '(.+%/).*')

        -- Check if the current file is not some kind of http stream or
        -- Spotify track (like spotify:track:5r65GeuIoebfJB5sLcuPoC)
        if not current_file_folder or string.match(current_file, "%w+://") then
            return -- Let the default image to be the cover
        end

        local folder = music_folder .. current_file_folder

        -- Get all images in the folder. Also escape occasional single
        -- quotes in folder name.
        local request = format("ls '%s' | grep -P '\\.jpg|\\.png|\\.gif|\\.jpeg'",
                               string.gsub(folder, "'", "'\\''"))

        local covers = self.pread(request, "*all")
        local covers_table = self.split(covers)

        if covers_table.n > 0 then
            result = folder .. covers_table[1]
            if covers_table.n > 1 then
                -- Searching for front cover with grep because Lua regular
                -- expressions suck:[
                local front_cover =
                self.pread('echo "' .. covers ..
                           '" | grep -P -i "cover|front|folder|albumart" | head -n 1', "*line")
                if front_cover then
                    result = folder .. front_cover
                end
            end
        end
        return result
    end
end

return awesompd
