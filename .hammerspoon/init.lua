hyper = {"ctrl", "alt", "cmd", "shift"}

hs.hotkey.bind(hyper, "v", function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)
hs.hotkey.bind(hyper, "t", function() hs.application.launchOrFocus("iTerm") end)
hs.hotkey.bind(hyper, "e", function() hs.application.launchOrFocus("IntelliJ IDEA Ultimate") end)
hs.hotkey.bind(hyper, "b", function() hs.application.launchOrFocus("Firefox") end)
hs.hotkey.bind(hyper, "m", function() hs.application.launchOrFocus("Messages") end)
hs.hotkey.bind(hyper, "g", function() hs.application.launchOrFocus("Fork") end)
hs.hotkey.bind(hyper, "s", function() hs.application.launchOrFocus("Slack") end)
hs.hotkey.bind(hyper, "d", function() hs.application.launchOrFocus("Spotify") end)

hs.loadSpoon("MiroWindowsManager")

hs.window.animationDuration = 0.1
spoon.MiroWindowsManager:bindHotkeys({
  up = {hyper, "k"},
  right = {hyper, "l"},
  down = {hyper, "j"},
  left = {hyper, "h"},
  fullscreen = {hyper, "f"}
})
