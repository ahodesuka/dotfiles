local awful = require("awful")
local gears = require("gears")

local wallpaper = { }

function wallpaper:create(args)
    args = args or { }
    local instance = { }
    setmetatable(instance,self)
    self.__index = self

    instance.dir = string.gsub(args.dir, " ", "\\ ")

    instance.timer = timer({ timeout = args.delay or 60 * 60 })
    instance.timer:connect_signal("timeout", function()
        instance:new_wall()
    end)

    instance:new_wall()

    return instance
end

function wallpaper:new_wall()
    self.files = { }
    local i = 1
    local cmd = "find " .. self.dir .. " -type f -iregex '.*\.\\(png\\|jpg\\)'"
    for f in io.popen(cmd):lines() do
        self.files[i] = f
        i = i + 1
    end

    i = 1
    if #self.files > 1 then
        i = math.random(1, #self.files)
        if self.files[i] == self.current then
            i = i ~= 1 and i + 1 or i - 1
        end
    end

    gears.wallpaper.maximized(self.files[i])
    self.current = self.files[i]
    self.timer:again()
end

function wallpaper:new()
    return function()
        self:new_wall()
    end
end

return wallpaper
