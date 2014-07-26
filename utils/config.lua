-- Type: Tag, Client, Screen, Layout, Wibox
-- Actions: Toggle, Switch, Move, Follow, restore, minimize
-- Descriptors: Left, Right, First, Last

-- TODO: Can I truely get rid of :raise() ? or do I want to remove raise from focus & have it everywhere else?

-- Declarations & setup
local preMaximizeLayouts = {}
for s = 1, screen.count() do
	preMaximizeLayouts[s] = {}
end



-- Layout
function switchToMaximizedLayout()
	-- If No Layout Stored Then
	if (not preMaximizeLayouts[mouse.screen][awful.tag.selected()]) then
		-- Store Current Layout
		preMaximizeLayouts[mouse.screen][awful.tag.selected()] = awful.layout.get(mouse.screen)
		-- Change to Maximized
		awful.layout.set(awful.layout.suit.max)
	end
end
function revertFromMaximizedLayout()
	-- Revert Maximize
	if (awful.layout.get(mouse.screen) == awful.layout.suit.max) then
		awful.layout.set(preMaximizeLayouts[mouse.screen][awful.tag.selected()])
		-- Nil so it is garbage collected
		preMaximizeLayouts[mouse.screen][awful.tag.selected()] = nil
	end
end
function goToLayout(direction) -- -1 for back, 1 for forward 
	-- if maximized to go first/last layout
	if awful.layout.get(mouse.screen) == awful.layout.suit.max then
		-- Determine Index
		local index
		if direction == -1 then
			index = #layouts	-- Last
		else
			index = direction	-- First
		end
		--  Set Layout
		awful.layout.set(layouts[index])
		-- Clear Maximized Layout
		preMaximizeLayouts[mouse.screen][awful.tag.selected()] = nil
	else
		awful.layout.inc(layouts, direction)
	end
end

-- Client
-- TODO: Determine if I can make the window adjust when the screen's working area changes
function toggleClientMultiFullscreen(c)
     awful.client.floating.toggle(c)
     if awful.client.floating.get(c) then
         local clientX = screen[1].workarea.x
         local clientY = screen[1].workarea.y
         local clientWidth = 0
         -- look at http://www.rpm.org/api/4.4.2.2/llimits_8h-source.html
         local clientHeight = 2147483640
         for s = 1, screen.count() do
             clientHeight = math.min(clientHeight, screen[s].workarea.height)
             clientWidth = clientWidth + screen[s].workarea.width
         end
         c.border_width = 0
         local t = c:geometry({x = clientX, y = clientY, width = clientWidth, height = clientHeight})
     else
     	c.border_width = beautiful.border_width
        --apply the rules to this client so he can return to the right tag if there is a rule for that.
        awful.rules.apply(c)
     end
     -- focus our client
     client.focus = c
end

-- Titlebar
function isTitlebarEnabledForClient(c)
	-- or c.type == "dialog"
	if not (c.type == "normal") then
		return false
	elseif c.class == "Plugin-container" then
		return false
	elseif c.class == "XTerm" then
		return false
	end
	return true
end
function toggleClientTitlebar(c)
	local titlebar = awful.titlebar(c)
	if titlebar.visible == true then
		titlebar.visible = false
		awful.titlebar(c, {size = 0})
	else
		addTitlebarToClient(c, titlebar)
		titlebar.visible = true
		-- titlebar
	end
end
function addTitlebarToClient(c, titlebar)
	local titlebar = titlebar or awful.titlebar(c)
	-- buttons for the titlebar
	local buttons = awful.util.table.join(
	  awful.button({}, 1, function()
		client.focus = c
		c:raise()
		awful.mouse.client.move(c)
	  end),
	  awful.button({}, 3, function()
		client.focus = c
		c:raise()
		awful.mouse.client.resize(c)
	  end))

	-- Widgets that are aligned to the left
	local left_layout = wibox.layout.fixed.horizontal()
	left_layout:add(awful.titlebar.widget.iconwidget(c))
	left_layout:buttons(buttons)

	-- Widgets that are aligned to the right
	right_layout = wibox.layout.fixed.horizontal()
	right_layout:add(awful.titlebar.widget.floatingbutton(c)) -- WAV: Replace with Key
	--right_layout:add(awful.titlebar.widget.maximizedbutton(c))
	right_layout:add(awful.titlebar.widget.stickybutton(c)) -- Dog (Stays with you whereever you go :p)
	-- WAV: Remove On Top
	--right_layout:add(awful.titlebar.widget.ontopbutton(c))
	right_layout:add(awful.titlebar.widget.closebutton(c)) -- Win + Q

	-- The title goes in the middle
	local middle_layout = wibox.layout.flex.horizontal()
	local title = awful.titlebar.widget.titlewidget(c, {fg_focus = "#FFFFFF"})
	title:set_align("center")
	middle_layout:add(title)
	middle_layout:buttons(buttons)

	-- Now bring it all together
	local layout = wibox.layout.align.horizontal()
	layout:set_left(left_layout)
	layout:set_right(right_layout)
	layout:set_middle(middle_layout)
	
	titlebar:set_widget(layout)
	titlebar.visible = true
end

--Signals
function manageClient(c, startup)
	--Mouse Over Focus
	c:connect_signal("mouse::enter",
	function(c)
		if awful.client.focus.filter(c) and awful.layout.get(c.screen) ~= awful.layout.suit.magnifier then
			client.focus = c
			c:raise()
		end
	end)

	if not startup then
		--Position.
		if not c.size_hints.user_position and not c.size_hints.program_position then
			awful.placement.no_overlap(c)
			awful.placement.no_offscreen(c)
		end
	end

	--TitleBar
	-- local titlebars_enabled = true
	if titlebars_enabled and isTitlebarEnabledForClient(c) then
		addTitlebarToClient(c)
	end
end

--Utility
function putToSleep()
	local screenDimens = screen[mouse.screen].workarea
	moveMouse(screenDimens.width / 2, screenDimens.height / 2)
	awful.util.spawn(COMMAND_SLEEP)
end

--Debugging
function debug_editor(object, recursion, editor)
	return awful.util.spawn_with_shell("echo \""..inspect(object, recursion or 1).."\" | "..editor)
end
function debug_leaf(object, recursion)
	return debug_editor(object, recursion, "leafpad")
end
function debug_subl(object, recursion)
	return debug_editor(object, recursion, "subl3 -n")
end
function debug_file(object, recursion, file)
	saveFile(inspect(object, recursion or 1), file or "debug.txt")
end

--Naughty
function wvprint(text, timeout)
	naughty.notify({preset = naughty.config.presets.normal, text = text, screen = screen.count(), timeout = timeout or 0})
end
toggleNaughtyNotifications = toggleStateFunc(function(enabled)
	if enabled then -- Disable Naughty
		wvprint("Naughty Suspended", 1)
		naughty.suspend()
	else -- Enable Naughty
		naughty.resume()
		wvprint("Naughty Resumed", 1)
	end
end, true)

-- System --
------------
-- Screen --
-- Brightness
function changeBrightness(incORDec, amount)
	awful.util.spawn_with_shell("sudo sh -c 'echo $(($(cat /sys/class/backlight/intel_backlight/brightness)"..incORDec..amount..")) > /sys/class/backlight/intel_backlight/brightness'")
end
-- IP
function retrieveIPAddress(device)
	local ip
	local tempProcess = io.popen("ip addr show dev "..device.." | awk '/([0-9].){4}/ {print $2}'")
	ip = tempProcess:read("*all")
	tempProcess:close()
	return ip
end



-- Hooking --
-------------

-- disable startup-notification globally
local oldspawn = awful.util.spawn
awful.util.spawn = function(s) oldspawn(s, false) end