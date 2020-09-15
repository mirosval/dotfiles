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
focus("s", "Slack")
focus("t", "TablePlus")
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
    print(w)
    if (where == "east") then w:moveOneScreenEast(false, true, 0)
    elseif (where == "west") then w:moveOneScreenWest(false, true, 0)
    elseif (where == "south") then w:moveOneScreenSouth(false, true, 0)
    elseif (where == "north") then w:moveOneScreenNorth(false, true, 0)
    end
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
