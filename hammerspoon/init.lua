hyper = {"ctrl", "alt", "cmd", "shift"}

function focus(key, app)
  hs.hotkey.bind(hyper, key, function() hs.application.launchOrFocus(app) end)
end

focus("a", "Alacritty")
focus("b", "Firefox")
focus("c", "Calendar")
focus("d", "Spotify")
focus("e", "IntelliJ IDEA CE")
focus("g", "Fork")
focus("m", "Messages")
focus("n", "Notion")
focus("q", "GraphiQL")
focus("r", "Google Chrome")
focus("s", "Slack")
focus("t", "DataGrip")
focus("v", "Visual Studio Code")
focus("z", "Discord")

hs.loadSpoon("MiroWindowsManager")

hs.window.animationDuration = 0
spoon.MiroWindowsManager:bindHotkeys({
  up = {hyper, "k"},
  right = {hyper, "l"},
  down = {hyper, "j"},
  left = {hyper, "h"},
  fullscreen = {hyper, "f"}
})

function moveWindow(where)
  if hs.window.focusedWindow() then
    local w = hs.window.frontmostWindow()
    local s = hs.screen.mainScreen()
    if (where == "east") then s = s:toEast()
    elseif (where == "west") then s = s:toWest()
    elseif (where == "south") then s = s:toSouth()
    elseif (where == "north") then s = s:toNorth()
    end
    w:moveToScreen(s)
  end
end

function move(key, where)
  hs.hotkey.bind(hyper, key, function() moveWindow(where) end)
end

-- The following functions bind hyper+{yuio} to move active window
-- to an adjacent screen 
move("y", "west")
move("u", "south")
move("i", "north")
move("o", "east")

hs.caffeinate.set("displayIdle", true, true)
hs.loadSpoon("Caffeine")
spoon.Caffeine:start()
