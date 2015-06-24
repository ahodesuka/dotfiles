local utils = require 'mp.utils'
local msg = require 'mp.msg'

local ls = {
    path = "livestreamer",
}


mp.add_hook("on_load", 9, function()
    local url = mp.get_property("stream-open-filename")

    if ls:can_handle_url(url) then
        local stream_url = ls:stream_url(url)
        if not stream_url then
            return
        end

        msg.debug("stream url: " .. stream_url)

        mp.set_property("stream-open-filename", stream_url)

        -- original URL since livestreamer doesn't give us anything better
        mp.set_property("file-local-options/force-media-title", url)
    end
end)


local function exec(...)
    local ret = utils.subprocess({args = {...}})
    return ret.status, ret.stdout
end


function ls:can_handle_url(url)
    return exec(self.path, "--can-handle-url", url) == 0
end


function ls:stream_url(url)
    local es, stream_url = exec(
        self.path, "--stream-url", "--stream-types", "hls,rtmp,http", url, "best"
    )

    if es == 0 then
        return stream_url:gsub("\n", "")
    end
end
