mp.register_event("file-loaded", function()
  if mp.get_property("fullscreen") == "yes" then
    mp.command("show-text ${media-title}")
  end
end)
