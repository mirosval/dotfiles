hyper = {"ctrl", "alt", "cmd", "shift"}

hs.hotkey.bind(hyper, "v", function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)
hs.hotkey.bind(hyper, "t", function() hs.application.launchOrFocus("iTerm") end)
hs.hotkey.bind(hyper, "i", function() hs.application.launchOrFocus("IntelliJ IDEA Ultimate") end)
hs.hotkey.bind(hyper, "b", function() hs.application.launchOrFocus("Firefox") end)
