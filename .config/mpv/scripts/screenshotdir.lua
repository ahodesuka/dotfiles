mputils = require 'mp.utils'

mp.register_event("start-file", function()
    local path = mp.get_property("path", "")
    local dir, filename = mputils.split_path(path)
    if #dir == 0 or dir:match("://") then
        return
    end

    mp.set_property("options/screenshot-directory", dir)
    mp.msg.info("Settings screenshot directory to " .. dir)
end)
