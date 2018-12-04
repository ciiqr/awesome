local awful = require("awful")
local gears = require("gears")
local xrandr = require("utils.xrandr")
local binding = require("utils.binding")

local environment = {
    awesome = awesome,
    widget_manager = WIDGET_MANAGER,
}

-- TODO: instead of expecting globals, maybe we just inject environment when we ask for keybindings
local keys = binding.createKeys(CONFIG.keybindings, environment)
local globalKeys = gears.table.join(unpack(keys))

-- Global Key Bindings
globalKeys = gears.table.join(globalKeys,
    -- Switch Between Tags
    awful.key({SUPER}, "Escape", awful.tag.history.restore),
    awful.key({ALT, CONTROL}, "Left", awful.tag.viewprev),
    awful.key({ALT, CONTROL}, "Right", awful.tag.viewnext),
    awful.key({ALT, CONTROL}, "Up", switchToFirstTag),
    awful.key({ALT, CONTROL}, "Down", switchToLastTag),

    -- Toggle Bars
    awful.key({SUPER}, "[", function() toggleWibox("topWibar"); toggleWibox("bottomWibar") end),
    awful.key({SUPER}, "]", function() toggleWibox("bottomWibar") end),
    awful.key({SUPER}, "c", toggleInfoWiboxes),

    -- Switch Layout
    awful.key({SUPER}, "space", function() goToLayout(FORWARDS) end),
    awful.key({SUPER, SHIFT}, "space", function() goToLayout(BACKWARDS) end),

    -- Switch Window
    awful.key({SUPER}, "Tab", function() switchClient(FORWARDS) end),
    awful.key({SUPER, SHIFT}, "Tab", function() switchClient(BACKWARDS) end),
    awful.key({SUPER}, "Next", function() switchClient(FORWARDS) end),
    awful.key({SUPER}, "Prior", function() switchClient(BACKWARDS) end),

    -- ClientRestore
    awful.key({SUPER, CONTROL}, "Up", restoreClient),

    -- Maximize
    awful.key({SUPER}, "Up", switchToMaximizedLayout),
    -- Revert Maximize
    awful.key({SUPER}, "Down", revertFromMaximizedLayout),

    -- Sleep
    awful.key({}, "XF86Sleep", function() awful.spawn.with_shell(CONFIG.commands.sleep) end),
    awful.key({SUPER, CONTROL}, "q", function() awful.spawn.with_shell(CONFIG.commands.sleep) end),

    -- Add Tag
    awful.key({SUPER}, "y", function()
        -- Add Tag
        local newTag = awful.tag.add("Tag "..(#awful.screen.focused().tags) + 1, {
            layout = awful.layout.layouts[1],
        })
        -- Switch to it
        newTag:view_only()
    end),

    -- Remove Tags
    awful.key({SUPER, SHIFT}, "y", function()
        local selectedTags = awful.screen.focused().selected_tags
        for i, tag in pairs(selectedTags) do
            tag:delete()
        end
    end),

    -- Change Position
    awful.key({SUPER}, "Left", function() awful.client.swap.byidx(BACKWARDS) end),
    awful.key({SUPER}, "Right", function() awful.client.swap.byidx(FORWARDS) end),

    -- Move Middle
    awful.key({SUPER, SHIFT}, "Left", function() increaseMwfact(-0.05) end),
    awful.key({SUPER, SHIFT}, "Right", function() increaseMwfact(0.05) end),
    -- awful.key({SUPER, SHIFT}, "Up", function() increaseClientWfact(-0.05, client.focus) end), -- TODO: To shift window up/down in size
    -- awful.key({SUPER, SHIFT}, "Down", function() increaseClientWfact(0.05, client.focus) end), -- TODO: To shift window up/down in size

    -- Change Number of Columns(Only on splitup side)
    awful.key({SUPER, CONTROL}, "h", function() awful.tag.incncol(FORWARDS) end),
    awful.key({SUPER, CONTROL}, "l", function() awful.tag.incncol(BACKWARDS) end),

    -- Switch beteen screens
    -- TODO: Make it depend on the number of attached screens
        -- Could just have a function that loops through the screen count & calls this the given number of times with the different numbers & joins them to a list
    -- perScreen(function(s)
    --  return awful.key({SUPER}, "F"..s, function() notify_send(s) end)
    -- end),
    awful.key({SUPER}, "F1", function() awful.screen.focus(1) end),
    awful.key({SUPER}, "F2", function() awful.screen.focus(2) end),
    awful.key({SUPER}, "F3", function() awful.screen.focus(3) end),

    -- Popups
    -- Launcher Style
    awful.key({SUPER}, "w", function() awful.spawn.with_shell(insertScreenWorkingAreaYIntoFormat(CONFIG.commands.fileOpener)) end),
    awful.key({SUPER}, "s", function() awful.spawn.with_shell(insertScreenWorkingAreaYIntoFormat(CONFIG.commands.windowSwitcher)) end),

    -- Programs
    awful.key({SUPER}, "t", function() awful.spawn(CONFIG.commands.terminal) end),

    awful.key({SUPER}, "Return", function() awful.spawn(CONFIG.commands.fileManager) end),
    awful.key({SUPER, SHIFT}, "Return", function() awful.spawn(CONFIG.commands.graphicalSudo.." "..CONFIG.commands.fileManager) end),

    awful.key({SUPER}, "o", function() awful.spawn.with_shell(CONFIG.commands.editor) end),
    awful.key({SUPER, SHIFT}, "o", function() awful.spawn.with_shell(CONFIG.commands.graphicalSudo.." "..CONFIG.commands.editor) end),

    -- Awesome
    -- awful.key({SUPER, CONTROL}, "r", awesome.restart),

    -- System
    -- Volume
    awful.key({}, "XF86AudioMute", function() WIDGET_MANAGER:toggleMute() end),
    awful.key({}, "XF86AudioLowerVolume", function() WIDGET_MANAGER:changeVolume("-", CONFIG.volume.change.normal) end),
    awful.key({}, "XF86AudioRaiseVolume", function() WIDGET_MANAGER:changeVolume("+", CONFIG.volume.change.normal) end),
    awful.key({SHIFT}, "XF86AudioLowerVolume", function() WIDGET_MANAGER:changeVolume("-", CONFIG.volume.change.small) end),
    awful.key({SHIFT}, "XF86AudioRaiseVolume", function() WIDGET_MANAGER:changeVolume("+", CONFIG.volume.change.small) end),

    -- Brightness
    -- TODO: only setup keybindings if brightness can be adjusted...
    awful.key({}, "XF86MonBrightnessUp", function() changeBrightness("+", CONFIG.brightness.change.normal) end),
    awful.key({}, "XF86MonBrightnessDown", function() changeBrightness("-", CONFIG.brightness.change.normal) end),
    awful.key({SHIFT}, "XF86MonBrightnessUp", function() changeBrightness("+", CONFIG.brightness.change.small) end),
    awful.key({SHIFT}, "XF86MonBrightnessDown", function() changeBrightness("-", CONFIG.brightness.change.small) end),

    -- Invert Screen
    awful.key({SUPER}, "i", function() awful.spawn.with_shell(CONFIG.commands.screenInvert) end),

    -- Print Screen
    awful.key({}, "Print", captureScreenshot),

    -- Print Screen (Select Area)
    awful.key({SUPER}, "Print", captureScreenSnip),

    -- Cycle Displays
    awful.key({SUPER}, "F11", xrandr),

    -- Pasteboard paste
    awful.key({}, "Insert", function() awful.spawn("xdotool click 2") end), -- put 'keycode 118 = ' back in .Xmodmap if I no longer use this
    awful.key({SUPER}, "Insert", pasteClipboardIntoPrimary) -- TODO: Figure out why it doesn't work

    -- -- Run or raise applications with dmenu
    -- TODO: Client itteration code may be useful, but otherwise I could probably implement this with QuickLaunch
    -- ,awful.key({SUPER, CONTROL}, "p", function()
    --  local beautiful = require("beautiful")
    --  local f_reader = io.popen( "dmenu_run | dmenu -b -nb '".. beautiful.bg_normal .."' -nf '".. beautiful.fg_normal .."' -sb '#955'")
    --  local command = assert(f_reader:read('*a'))
    --  f_reader:close()
    --  if command == "" then return end

    --  -- Check throught the clients if the class match the command
    --  local lower_command=string.lower(command)
    --  for k, c in pairs(client.get()) do
    --      local class=string.lower(c.class)
    --      if string.match(class, lower_command) then
    --          for i, v in ipairs(c:tags()) do
    --              v:view_only()
    --              c.minimized = false
    --              return
    --          end
    --      end
    --  end
    --  awful.spawn(command)
    -- end)
)

-- Tag Keys
-- Uses keycodes to make it works on any keyboard layout
local numberOfTags = #awful.screen.focused().tags
for i = 1, numberOfTags do
    local iKey = "#"..(i + 9)
    globalKeys = gears.table.join(globalKeys,
        awful.key({ALT, CONTROL},       iKey, function() switchToTag(i) end),
        awful.key({SUPER, ALT},         iKey, function() moveClientToTagAndFollow(i) end),

        -- NOTE: Never Used
        awful.key({SUPER, SHIFT},       iKey, function() toggleTag(i) end),
        awful.key({SUPER, CONTROL, ALT},iKey, function() toggleClientTag(i) end)) -- TODO: Change to Control, Alt Shift to be more like mod shift for toggling a tag visibility
end

return globalKeys