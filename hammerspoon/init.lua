hyper = {"ctrl", "alt", "cmd", "shift"}

hs.hotkey.bind(hyper, "v", function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)
hs.hotkey.bind(hyper, "a", function() hs.application.launchOrFocus("Alacritty") end)
hs.hotkey.bind(hyper, "q", function() hs.application.launchOrFocus("GraphiQL") end)
hs.hotkey.bind(hyper, "e", function() hs.application.launchOrFocus("IntelliJ IDEA CE") end)
hs.hotkey.bind(hyper, "t", function() hs.application.launchOrFocus("TablePlus") end)
hs.hotkey.bind(hyper, "b", function() hs.application.launchOrFocus("Firefox") end)
hs.hotkey.bind(hyper, "c", function() hs.application.launchOrFocus("Visual Studio Code") end)
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

hs.caffeinate.set("displayIdle", true, true)
hs.loadSpoon("Caffeine")
spoon.Caffeine:start()

local function openLunchBuddy()
    -- This is almost good, but Firefox will always open a NEW tab instead of reusing exisitng
    hs.urlevent.openURL("https://lunch-buddy.jimdo-platform.net/app/")
end

local function prewarmLunchBuddy()
    if hs.wifi.currentNetwork() == "jimdo-guest" then
        local notification = hs.notify.new(openLunchBuddy)
        notification:title("You're on jimdo-guest!")
        notification:informativeText("LunchBuddy will not work!")
        notification:withdrawAfter(300)
        notification:send()
    end
    openLunchBuddy()
end

local function notifyLunch()
    if (os.date("%A") ~= "Saturday" and os.date("%A") ~= "Sunday") then
        local notification = hs.notify.new(openLunchBuddy)
        notification:title("Lunch!")
        notification:withdrawAfter(30)
        notification:send()
    end
end

hs.timer.doAt("10:40:00", "1d", prewarmLunchBuddy)
hs.timer.doAt("10:59:10", "1d", notifyLunch)

