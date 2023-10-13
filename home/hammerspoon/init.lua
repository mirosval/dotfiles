local hyper = { "ctrl", "alt", "cmd", "shift" }

local focus = function(key, apps)
  local do_focus = function(app)
    local found = hs.application.launchOrFocus(app)
    -- The selected application is not frontmost, but this
    -- only brings the first window to the front, we want
    -- all the windows in the front
    hs.application.frontmostApplication():setFrontmost(true)
    return found
  end
  local bind = function()
    if type(apps) == "table" then
      for i = 1, #apps do
        if do_focus(apps[i]) then
          break
        end
      end
    else
      do_focus(apps)
    end
  end
  hs.hotkey.bind(hyper, key, bind)
end

-- Keyboard row 1
focus("q", "GraphiQL")
focus("w", "Lens")
focus("e", "IntelliJ IDEA")
focus("r", "Google Chrome")
focus("t", { "DataGrip", "Terminal" })
-- Keyboard row 2
focus("a", "Alacritty")
focus("s", "Slack")
focus("d", "Spotify")
-- focus("f", "") -- HYPER + F is used for Fullscreen
focus("g", "Fork")
-- Keyboard row 3
focus("z", "Zoom.us")
focus("x", "Discord")
focus("c", "Calendar")
focus("v", "Visual Studio Code")
focus("b", "Firefox")
-- Keyboard row 3, right hand
focus("m", "Messages")
focus("n", "Logseq")

hs.loadSpoon("MiroWindowsManager")

hs.window.animationDuration = 0
spoon.MiroWindowsManager:bindHotkeys({
  up = { hyper, "k" },
  right = { hyper, "l" },
  down = { hyper, "j" },
  left = { hyper, "h" },
  fullscreen = { hyper, "f" }
})

local moveWindow = function(where)
  if hs.window.focusedWindow() then
    local w = hs.window.frontmostWindow()
    local s = hs.screen.mainScreen()
    if (where == "east") then
      s = s:toEast()
    elseif (where == "west") then
      s = s:toWest()
    elseif (where == "south") then
      s = s:toSouth()
    elseif (where == "north") then
      s = s:toNorth()
    end
    w:moveToScreen(s)
  end
end

local move = function(key, where)
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
