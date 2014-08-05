-- Type: Tag, Client, Screen, Layout, Wibox
-- Actions: Toggle, Switch, Move, Follow, restore, minimize
-- Descriptors: Left, Right, First, Last

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
-- TODO: Determine if I can make the window adjust when the screen's working area changes, add listener when fullscreen, remove when not
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

function debugClient(c)
	-- Window Info
	-- notify_send("size_hints: "..inspect(c.size_hints))
	
	debug_print(c.transient_for)
	
	-- Object Info
	-- notify_send("InfoWibox:"..inspect(infoWibox[mouse.screen], 2))
	
	-- notify_send("InfoLayout:"..inspect(infoWibox[mouse.screen].drawin.height, 3))
	
	-- -- infoLayout:set_max_widget_size(100)
	-- notify_send("InfoLayout:"..inspect(infoLayout, 3))
	-- notify_send("Drawable:"..inspect(infoWibox[mouse.screen]._drawable, 2))
	-- notify_send("Drawable.Widget:"..inspect(infoWibox[mouse.screen]._drawable.widget, 2))
	
	-- Root Object Info
	-- notify_send(inspect(root, 4))
	-- for prop,val in pairs(root) do
	-- 	notify_send(prop .. inspect(val(), 4))
	-- end
	
	-- DBus
	
	-- dbus.connect_signal("org.freedesktop.NetworkManager.Device.Wireless.PropertiesChanged", function (body, bodyMarkup, iconStatic) notify_send("Got DBUS Notification!!!") end)
	-- dbus.request_name("session", "org.freedesktop.NetworkManager.Device.Wireless.PropertiesChanged")

	-- dbus.request_name("system", "org.freedesktop.NetworkManager.Device.Wireless")
	-- dbus.add_match("system", "interface='org.freedesktop.NetworkManager.Device.Wireless',member='PropertiesChanged'")
	-- dbus.connect_signal("org.freedesktop.NetworkManager.Device.Wireless", function(first, property, ...)
	-- 	ipAddress = property["Ip4Adress"]
	-- 	if ipAddress then
	-- 		notify_send(ipAddress)
	-- 	end
	-- 	-- notify_send(inspect(first, 3))
	-- 	-- notify_send(inspect(property, 3))
	-- end)

	-- dbus.request_name("system", "org.freedesktop.DBus.Properties")
	-- dbus.add_match("system", "interface='org.freedesktop.DBus.Properties',member='GetAll',string='org.freedesktop.NetworkManager.Device.Wireless")
	-- dbus.connect_signal("org.freedesktop.DBus.Properties", function(first, property, third, fourth, fifth, ...)
	-- 	notify_send("There is a Dog!")
	-- 	-- ipAddress = property["Ip4Adress"]
	-- 	if ipAddress then
	-- 		notify_send(ipAddress)
	-- 	end
	-- 	-- notify_send(inspect(first, 3))
	-- 	notify_send(inspect(property, 3))
	-- 	notify_send(inspect(third, 3))
	-- 	notify_send(inspect(fourth, 3))
	-- 	notify_send(inspect(fifth, 3))
	-- end)
	-- 

	-- Working
	-- dbus.request_name("system", "org.freedesktop.NetworkManager")
	-- dbus.add_match("system", "interface='org.freedesktop.NetworkManager',member='PropertiesChanged'")
	-- dbus.connect_signal("org.freedesktop.NetworkManager", function(first, ...)
	-- 	notify_send("FFS, It Worked!!")
	-- 	debug_leaf(first)
	-- end)
end

-- Titlebar
local function isTitlebarEnabledForClient(c)
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
local function addTitlebarToClient(c, titlebar)
	local titlebar = titlebar or awful.titlebar(c)
	-- buttons for the titlebar
	local buttons = awful.util.table.join(
	  awful.button({}, 1, function()
		client.focus = c
		awful.mouse.client.move(c)
	  end),
	  awful.button({}, 3, function()
		client.focus = c
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

--Signals
local function transientShouldBeSticky(c)
	return (c.name and c.name:find("LEAFPAD_QUICK_NOTE")) -- or 
end

function manageClient(c, startup)
	-- When first created
	if not startup then
		-- Position
		if not c.size_hints.user_position and not c.size_hints.program_position then
			awful.placement.no_overlap(c)
			awful.placement.no_offscreen(c)
		end
	end
	
	-- Subwindows Sticky
	if c.transient_for and transientShouldBeSticky(c) then
		notify_send("Transient's UNITE!")
		c.sticky = true
	end

	
	-- TitleBar (If Enabled)
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
function captureScreenShot()
	-- Capture
	awful.util.spawn_with_shell(COMMAND_SCREEN_SHOT)
	-- Display Naughty
	delayFunc(0.5, function()
		notify_send("ScreenShot Taken", 1)
	end)
end
function captureScreenSnip()
	-- TODO: Use Popen (presumable) in onder to know when it actually finishes, this way I can display the notification right after it was taken
	-- Capture
	awful.util.spawn_with_shell(os.date(COMMAND_SCREEN_SHOT_SELECT))
end

--Debugging
function debug_string(object, recursion)
	return inspect(object, recursion or 2)
end
function debug_editor(object, recursion, editor)
	return awful.util.spawn_with_shell("echo \""..debug_string(object, recursion).."\" | "..editor)
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
function debug_print(object, recursion)
	notify_send(debug_string(object, recursion))
end

--Naughty
function notify_send(text, timeout, preset)
	naughty.notify({preset=preset or naughty.config.presets.normal,
					  text=text,
					screen=screen.count(),
				   timeout=timeout or 0})
end
toggleNaughtyNotifications = toggleStateFunc(function(enabled)
	if enabled then -- Disable Naughty
		notify_send("Naughty Suspended", 1)
		naughty.suspend()
	else -- Enable Naughty
		naughty.resume()
		notify_send("Naughty Resumed", 1)
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