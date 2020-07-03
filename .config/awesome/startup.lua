local awful = require("awful")

awful.spawn.easy_async("xrdb -query", function(stdout, stderr, reason, exit_code)
  local xresources_name = "awesome.started"
  --local xresources = awful.util.pread("xrdb -query")
  if not stdout:match(xresources_name) then
    awful.spawn("dex --environment Awesome --autostart --search-paths $XDG_CONFIG_HOME/autostart &")
    awful.util.spawn_with_shell("xrdb -merge <<< '" .. xresources_name .. ":true'")
  end
end)
