local beautiful = beautiful or require("beautiful")
local vicious = vicious or require("vicious")
local quake = quake or require("quake")

local WidgetManager = {}

-- TODO: Either make this a per machine config setting or change the device names to be wlan* and eth*
WidgetManager.wifiDevice = "wlp2s0"
WidgetManager.ethDevice = "eth0"

-- Popup Terminal
function WidgetManager:initPopupTerminal(s)
	-- Ensure we have a table
	if not self.quake_terminal then
		self.quake_terminal = {}
	end
	
	-- Create Popup Terminal
	self.quake_terminal[s] = quake({ terminal = TERMINAL, height = 0.35, screen = s, width = 0.5})
	
	return self.quake_terminal[s]
end
function WidgetManager:togglePopupTerminal(s)
	-- Toggle Popup
	self.quake_terminal[s or mouse.screen.index]:toggle()
end

-- Popup CPU
function WidgetManager:initPopupCPU(s)
	-- Ensure we have a table
	if not self.quake_htop_cpu_terminal then
		self.quake_htop_cpu_terminal = {}
	end
	
	-- Create Popup CPU
	self.quake_htop_cpu_terminal[s] = quake({terminal=TERMINAL, argname="-name %s -e "..COMMAND_TASK_MANAGER_CPU, name="QUAKE_COMMAND_TASK_MANAGER_CPU", height=0.75, screen=s, width=0.5, horiz="right"})
	
	return self.quake_htop_cpu_terminal[s]
end
function WidgetManager:togglePopupCPU(s)
	-- Toggle Popup
	self.quake_htop_cpu_terminal[s or mouse.screen.index]:toggle()
end

-- Popup Memory
function WidgetManager:initPopupMemory(s)
	-- Ensure we have a table
	if not self.quake_htop_mem_terminal then
		self.quake_htop_mem_terminal = {}
	end
	
	-- Create Popup Memory
	self.quake_htop_mem_terminal[s] = quake({terminal=TERMINAL, argname="-name %s -e "..COMMAND_TASK_MANAGER_MEM, name="QUAKE_COMMAND_TASK_MANAGER_MEM", height=0.75, screen=s, width=0.5, horiz="left"})
	
	return self.quake_htop_mem_terminal[s]
end
function WidgetManager:togglePopupMemory(s)
	-- Toggle Popup
	self.quake_htop_mem_terminal[s or mouse.screen.index]:toggle()
end

-- Popup Notes
function WidgetManager:initPopupNotes(s)
	-- Ensure we have a table
	if not self.quake_leafpad_quick_note then
		self.quake_leafpad_quick_note = {}
	end
	
	-- Create Popup Notes
	self.quake_leafpad_quick_note[s] = quake({terminal = "leafpad", argname="--name=%s", name="LEAFPAD_QUICK_NOTE", height = 0.35, screen = s, width = 0.5})
	
	return self.quake_leafpad_quick_note[s]
end
function WidgetManager:togglePopupNotes(s)
	-- Toggle Popup
	self.quake_leafpad_quick_note[s or mouse.screen.index]:toggle()
end

function WidgetManager:initKeepass(s)
	-- Ensure we have a table
	if not self.quake_keepass then
		self.quake_keepass = {}
	end
	
	-- Create Popup Notes
	self.quake_keepass[s] = quake({terminal = "keepassx", name="keepassx", height = 0.75, screen = s, width = 0.5}) -- argname="--name=%s", 
	
	return self.quake_keepass[s]
end
function WidgetManager:toggleKeepass(s)
	-- Toggle Popup
	self.quake_keepass[s or mouse.screen.index]:toggle()
end

-- Volume
function WidgetManager:getVolume()
	self.volume = wibox.widget.textbox() -- 🔇 -- Mute icon --
	self.volume:buttons(awful.util.table.join(
		awful.button({}, MOUSE_SCROLL_UP, function() WidgetManager:changeVolume("+", 1) end),
		awful.button({}, MOUSE_SCROLL_DOWN, function() WidgetManager:changeVolume("-", 1) end),
		awful.button({}, 1, function() run_once("pavucontrol") end)
	))
	
	-- TODO: Remove timer for this, cause I want to use a service that notifies us...
	volTimer = timer({timeout = 5})
	volTimer:connect_signal("timeout", function()
		self:displayVolume()
	end)
	volTimer:start()
	
	
	self:displayVolume()
	return self.volume
end
function WidgetManager:changeVolume(incORDec, change)
	local change = change or VOLUME_CHANGE_NORMAL

	-- Change with amixer
	awful.util.spawn("amixer set Master "..change.."%"..incORDec)
end
function WidgetManager:toggleMute()
	awful.util.spawn('amixer -D pulse set Master 1+ toggle')
end
function WidgetManager:displayVolume(vol)
	local displayValue
	
	if vol then
		displayValue = math.floor(vol)
	else
		displayValue = self:retrieveSystemVolumeLevel()
	end
	
	self.volume:set_markup('<span foreground="#ffaf5f" weight="bold">🔈 '..displayValue.."%"..'</span>')
end
function WidgetManager:retrieveSystemVolumeLevel()
	local mixer = execForOutput("amixer get Master")
	
	-- Capture mixer control state:          [5%] ... ... [on]
	local volu, mute = string.match(mixer, "([%d]+)%%.*%[([%l]*)")
	-- Handle mixers without data
	if volu == nil then
		volu = "Off" -- TODO: Fix this for startup
	end

	-- -- Handle mixers without mute  -- Handle mixers that are muted
	-- if (mute == "" and volu == "0")  or mute == "off" then
	-- 	self:displayVolume("Muted")--mute = mixer_state["off"]
	-- else
	-- 	self:displayVolume(volu or "")
	-- end
	
	return volu
end

-- Memory
function WidgetManager:getMemory(vertical)
	self.memory = wibox.widget.textbox()
	if vertical then
		self.memory:set_align("center")
	end
	vicious.register(self.memory, vicious.widgets.mem, "<span fgcolor='#138dff' weight='bold'>$1% $2MB</span>", 13) --DFDFDF
	self.memory:buttons(awful.util.table.join(
		awful.button({}, 1, function() self:togglePopupMemory() end)
	))
	return self.memory
end

-- CPU
function WidgetManager:getCPU(vertical)
	local cpuwidget = awful.widget.graph()
	if not vertical then
		cpuwidget:set_width(50)
	end
	cpuwidget:set_background_color("#494B4F00") --55
	cpuwidget:set_color({ type = "linear", from = { 25, 0 }, to = { 25,22 }, stops = { {0, "#FF0000" }, {0.5, "#de5705"}, {1, "#00ff00"} }  })
	vicious.register(cpuwidget, vicious.widgets.cpu, "$1")
	cpuwidget:buttons(awful.util.table.join(
		awful.button({}, 1, function() self:togglePopupCPU() end)
	))
	return cpuwidget
end

-- System Tray
function WidgetManager:getSystemTray(vertical)
	self.sysTray = wibox.widget.systray()
	self.sysTray.set_horizontal(not vertical)
	self.sysTray.isSysTray = true
	self.sysTray.orig_fit = self.sysTray.fit
	self.sysTray.fit = function(self, ctx, width, height)
		-- Original
		local width, height = self:orig_fit(ctx, width, height)
		
		-- Hidden
		if self.hidden then
			return 0, 0
		else-- Visible
			return width, height
		end
	end
	return self.sysTray
end

-- IP
function WidgetManager:getIP()
	self.ip = wibox.widget.textbox()
	self.ip:set_align("center")
	
	self:updateIP()

	-- self.ip:buttons(awful.util.table.join(
	-- 	awful.button({}, 1, function() awful.util.spawn_with_shell(TERMINAL_EXEC.."'ip addr show; read -n'") end)
	-- 	-- ,awful.button({}, 3, function() self.ip:updateIP() end)
	-- ))
	return self.ip
end

function WidgetManager:updateIP()
	local ip = retrieveIPAddress(self.ethDevice)
	if ip == "" then
		ip = retrieveIPAddress(self.wifiDevice)
	end
	self.ip:set_text(ip)
end

-- Text Clock
function WidgetManager:getTextClock() -- .textClock:set_font()
	self.textClock = awful.widget.textclock('<span foreground="#94738c">%A, %B %d</span>  <span foreground="#ecac13">%I:%M %p</span>', 10) -- TODO: Add constant...
	-- Add Calendar
	require("cal").register(self.textClock, '<span weight="bold" foreground="'..(beautiful.taglist_fg_focus or beautiful.fg_focus or "")..'" underline="single">%s</span>')
	return self.textClock
end


function WidgetManager:getTaskBox(screen, is_vertical)
	-- TODO: These need to be seperate per screen, therefore I need a list for each, ie. WidgetManager.verticalTaskBoxes, WidgetManager.horizontalTaskBoxes
	local buttons = awful.util.table.join(
		awful.button({}, 1, toggleClient),
		awful.button({}, 3, toggleInfoWiboxes)
	)
	if is_vertical then
		local layout = wibox.layout.flex.vertical()
		local widget = awful.widget.tasklist(screen, awful.widget.tasklist.filter.allscreen, buttons, nil, nil, layout) -- Vertical
		-- layout:fit_widget(widget, 100, 100)
		layout:fit({}, 100, 100)
		widget:fit({}, 100, 100)
		-- widget = awful.widget.layoutbox(screen)
		-- notify_send(inspect(layout, 2))
		-- notify_send(inspect(widget, 2))
		return widget
	else
		-- TODO: Consider minimizedcurrenttags for filter, it's pretty interesting, though, I would want it to hide if the bottom if there we're no items, or maybe move it back to the top bar & get rid of the bottom entirely...
		return awful.widget.tasklist(screen, awful.widget.tasklist.filter.currenttags, buttons) -- Normal
		-- allscreen,  All on Screen, Normal
	end
end

function WidgetManager:getAllWindowsWibox(s, widget)
	local scaling_factor = xresources.get_dpi(s) / 96
	-- 'awful.wibox' to have it affect the workarea
	local aWibox = wibox({
		position = "left",
		screen = s,
		width = 300 * scaling_factor,
		ontop = true,
		visible = false})
	aWibox:set_widget(widget)
	
	-- Function to resize the wibox
	local sizeWibox = function(screen)
		-- Adjust the AllWindowsWibox's height when the working area changes
		aWibox.y = screen.workarea.y
		aWibox.height = screen.workarea.height
	end
	
	local ourScreen = screen[s]
	-- Set the initial size
	sizeWibox(ourScreen)
	-- Resize on working area change
	ourScreen:connect_signal("property::workarea", sizeWibox)
	
	-- TODO: on task list change it should update height, never more than workarea
	return aWibox
end

function WidgetManager:getSysInfoWibox(s, widget)
	local ourScreen = screen[s]
	local scaling_factor = xresources.get_dpi(s) / 96
	local width = 120 * scaling_factor
	-- 'awful.wibox' to have it affect the workarea
	local aWibox = wibox({
		position = "right",
		screen = s,
		x = ourScreen.workarea.width - width,
		width = width,
		-- bg = "#222222FF",
		-- bg = "22222288",
		-- bg = "linear:0,0:"..width..",0:0,#22222200:0.25,#22222266:0.5,#2222227F:1,#",
		-- bg = { type = "linear", from = {0, 0}, to = {width, 0}, stops = {{0, "#22222200"}, {0.5, "#2222227F"}, {1, "#22222288"}}},
		ontop = true,
		visible = false
	})

	aWibox:set_widget(widget)
	
	-- Function to resize the wibox
	local sizeWibox = function(screen)
		-- Adjust the AllWindowsWibox's height when the working area changes
		aWibox.y = screen.workarea.y
		aWibox.height = screen.workarea.height
	end
	
	-- Set the initial size
	sizeWibox(ourScreen)
	-- Resize on working area change
	ourScreen:connect_signal("property::workarea", sizeWibox)
	
	return aWibox
end

-- TagsList
function WidgetManager:getTagsList(screen)
	-- TODO: Consider Moving
	local buttons = awful.util.table.join(
		awful.button({}, 1, awful.tag.viewonly), -- Switch to This Tag
		awful.button({SUPER}, 1, awful.client.movetotag), -- Move Window to This Tag
		awful.button({}, 3, awful.tag.viewtoggle), -- Toggle This Tag 
		awful.button({SUPER}, 3, awful.client.toggletag)--, -- Toggle This Tag For The current Window
	)

	--TagList
	-- TODO: CHange so it stores the tagsList for all screens
	-- self.tagsList = awful.widget.taglist(screen, awful.widget.taglist.filter.noempty, buttons)
	self.tagsList = awful.widget.taglist(screen, awful.widget.taglist.filter.all, buttons)
	return self.tagsList
end

-- LayoutBox
function WidgetManager:getLayoutBox(screen)
	-- TODO: CHange so it stores the layoutBoxes for all screens
	self.layoutBox = awful.widget.layoutbox(screen)
	self.layoutBox:buttons(awful.util.table.join(
		awful.button({}, 1, function() goToLayout(1) end)
		,awful.button({}, 3, function() goToLayout(-1) end)
	))

	return self.layoutBox
end

-- Temperature
function WidgetManager:getTemperature()
	self.temperature = require("widgets.temperature"):init()
	return self.temperature
end

-- Net Usage
function WidgetManager:getNetUsage(vertical)
	-- TODO: Make some changes
	self.netwidget = wibox.widget.textbox()
	if vertical then
		self.netwidget:set_align("center")
	end
	vicious.register(self.netwidget, vicious.widgets.net, '<span foreground="#97D599" weight="bold">↑${'..WidgetManager.wifiDevice..' up_mb}</span> <span foreground="#CE5666" weight="bold">↓${'..WidgetManager.wifiDevice..' down_mb}</span>', 1) --#585656
	self.netwidget:buttons(awful.util.table.join(
		awful.button({}, 1, function() awful.util.spawn(TERMINAL_EXEC.." sudo nethogs "..WidgetManager.wifiDevice.."") end)
	))

	-- TODO
	-- dbus.connect_signal("org.freedesktop.Notifications", function(signal, value)

		-- notify_send("org.freedesktop.Notifications")
	 --    notify_send(inspect({signal, value}, 2))
	-- end)

	--dbus.connect_signal("org.freedesktop.Notifications", 

	return self.netwidget
end

-- Battery
function WidgetManager:getBatteryWidget()
	-- TODO: Make so we can update from acpi, ie. DBus acpi notifications
	self.battery = wibox.widget.textbox()
	function customWrapper(format, warg)

		local retval = vicious.widgets.bat(format, warg) -- state, percent, time, wear
		local batteryPercent = retval[2]
		
		if retval[3] == "N/A" then -- Time
			retval[3] = ""
		else
			retval[3] = " "..retval[3]
		end
		
		-- On Battery
		if retval[1] == "−" then
			local function notify_battery_warning(level)
				notify_send(level.." Battery: "..batteryPercent.."% !", 0, naughty.config.presets.critical)
			end
			-- Low Battery
			if batteryPercent < BATTERY_PERCENT_LOW then
				notify_battery_warning("Low")
			elseif batteryPercent < BATTERY_PERCENT_CRITICAL then
				notify_battery_warning("Critical")
			end
		end
		return retval
	end
	-- TODO: Have a setting for the battery to use
	vicious.register(self.battery, customWrapper, '<span foreground="#ffcc00" weight="bold">$1$2%$3</span>', 120, "BAT0") --585656
	
	return self.battery
end

return WidgetManager
