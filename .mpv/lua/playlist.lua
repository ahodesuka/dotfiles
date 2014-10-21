-- playlist.lua
--
-- Automatically adds files from the same directory
-- to the playlist.

local msg = require 'mp.msg'
local utils = require 'mp.utils'

local current_dir = nil

table.indexOf = function(t, x)
    for k, v in pairs(t) do
        if x == v then return k end
    end
end

function alphanumsort(t)
    local function padnum(d) return ("%012d"):format(d) end
    table.sort(t, function(a,b)
        return tostring(a):gsub("%d+",padnum) <
               tostring(b):gsub("%d+",padnum)
    end)
    return t
end

mp.register_event("file-loaded", function()
    local dir = utils.split_path(mp.get_property("path"))
    if dir ~= current_dir then
        local entries = utils.readdir(dir, "files")
        if entries ~= nil then
            entries = alphanumsort(entries)
            local index = table.indexOf(entries, mp.get_property("filename"))
            if index ~= nil then
                index = index - 1
                current_dir = dir
                mp.commandv("playlist_clear")
                for k, v in pairs(entries) do
                    mp.commandv("loadfile", utils.join_path(current_dir, v), "append")
                end
                mp.commandv("playlist_remove", "current")
                mp.set_property("playlist-pos", index)
            end
        end
    end
end)
