-- scrobbler.lua

local user_opts = {
    scrobbler = "anidb",
    percent = 0.5
}

local timer_handle = nil
local duration = 0
local watched = 0
local paused = false

function timer_fn()
    if not paused then
        watched = watched + 1
        if watched >= math.floor(duration * user_opts.percent + 0.5) then
            os.execute(user_opts.scrobbler .. " " ..
                       string.format("%q", mp.get_property("path")) .. " &")
            mp.cancel_timer(timer_handle)
        end
    end
end

function on_file_loaded()
    if timer_handle ~= nil then
        mp.cancel_timer(timer_handle)
    end
    watched = 0
    duration = mp.get_property("duration")
    paused = mp.get_property("pause") == "yes"
    if duration ~= nil then
        duration = math.floor(duration + 0.5)
        timer_handle = mp.add_periodic_timer(1, timer_fn)
    end
end

mp.register_event("file-loaded", on_file_loaded)
mp.register_event("pause", function() paused = true end)
mp.register_event("unpause", function() paused = false end)
