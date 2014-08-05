local beautiful = beautiful or require("beautiful")
local vicious = vicious or require("vicious")
local quake = quake or require("quake")

local WidgetManager = {}

if IS_LAPTOP then
	WidgetManager.wifiDevice = "wlp9s0"
	WidgetManager.ethDevice = "enp8s0"
else
	WidgetManager.wifiDevice = "wlp0s29u1u7"
	WidgetManager.ethDevice = "enp2s0"
end

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
	self.quake_terminal[s or mouse.screen]:toggle()
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
	self.quake_htop_cpu_terminal[s or mouse.screen]:toggle()
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
	self.quake_htop_mem_terminal[s or mouse.screen]:toggle()
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
	self.quake_leafpad_quick_note[s or mouse.screen]:toggle()
end

-- Volume
function WidgetManager:getVolume()
	self.volume = wibox.widget.textbox() -- 🔇 -- Mute icon --
	self.volume:buttons(awful.util.table.join(
		awful.button({}, 4, function() WidgetManager:changeVolume("+", 1) end),
		awful.button({}, 5, function() WidgetManager:changeVolume("-", 1) end),
		awful.button({}, 1, function() run_once("pavucontrol") end)
	))
	self:changeVolume("+", 0)
	return self.volume
end
function WidgetManager:changeVolume(incORDec, change)
	local change = change or VOLUME_CHANGE_NORMAL

	-- Get mixer control contents
	local f = io.popen("amixer set Master "..change.."%"..incORDec)
	local mixer = f:read("*all")
	f:close()

	-- Capture mixer control state:          [5%] ... ... [on]
	local volu, mute = string.match(mixer, "([%d]+)%%.*%[([%l]*)")
	-- Handle mixers without data
	if volu == nil then
		self:setVolumeWidget("Off")
		return
	end

	-- Handle mixers without mute  -- Handle mixers that are muted
	if (mute == "" and volu == "0")  or mute == "off" then
		self:setVolumeWidget("Muted")--mute = mixer_state["off"]
	else
		self:setVolumeWidget(volu or "")
	end
end
function WidgetManager:setVolumeWidget(vol)
	-- TODO: volIcon
	-- Snippets
	-- vol = tonumber(vol)
	-- if vol == 0 or vol == nil then
  		-- volIcon = "
	-- self.volume:set_markup('<span foreground="#ffaf5f" weight="bold">'..volIcon..' '..vol.."%  "..'</span>') \nend

	-- TODO: Temp
	self.volume:set_markup('<span foreground="#ffaf5f" weight="bold">🔈 '..vol.."%  "..'</span>')
end

-- Memory
function WidgetManager:getMemory()
	self.memory = wibox.widget.textbox()
	vicious.register(self.memory, vicious.widgets.mem, "<span fgcolor='#138dff'>$1% $2MB</span>  ", 13) --DFDFDF
	self.memory:buttons(awful.util.table.join(
		awful.button({}, 1, function() self:togglePopupMemory() end)
	))
	return self.memory
end

-- CPU
function WidgetManager:getCPU()
	local cpuwidget = awful.widget.graph()
	cpuwidget:set_width(50)
	cpuwidget:set_background_color("#494B4F00") --55
	cpuwidget:set_color({ type = "linear", from = { 25, 0 }, to = { 25,22 }, stops = { {0, "#FF0000" }, {0.5, "#de5705"}, {1, "#00ff00"} }  })
	vicious.register(cpuwidget, vicious.widgets.cpu, "$1")
	cpuwidget:buttons(awful.util.table.join(
		awful.button({}, 1, function() self:togglePopupCPU() end)
	))
	return cpuwidget
end

-- System Tray
function WidgetManager:getSystemTray()
	self.sysTray = wibox.widget.systray()
	self.sysTray.isSysTray = true
	self.sysTray.orig_fit = self.sysTray.fit
	self.sysTray.fit = function(self, width, height)
		-- Original
		local width, height = self:orig_fit(width, height)
		
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
	local ip = retrieveIPAddress(self.wifiDevice)
	if not ip or ip == "" then
		ip = retrieveIPAddress(self.ethDevice)
	end

	self.ip = wibox.widget.textbox(ip)
	self.ip:set_align("center")

	self.ip:buttons(awful.util.table.join(
		awful.button({}, 1, function() awful.util.spawn_with_shell(TERMINAL_EXEC.."'ip addr show; read -n'") end)
	))
	return self.ip
end

-- Main Menu Button
function WidgetManager:getMainMenuButton()
	self.mainMenu = require("MainMenu")
	self.mainMenuButton = awful.widget.launcher({image = beautiful.arch_icon, menu = self.mainMenu, coords = {x = 0, y = 0}})
	return self.mainMenuButton
end

-- Text Clock
function WidgetManager:getTextClock()
	self.textClock = awful.widget.textclock('  <span foreground="#94738c">%A, %B %d</span>  <span foreground="#ecac13">%I:%M %p</span>  ', 10)
	-- Add Calendar
	require("cal").register(self.textClock, '<span weight="bold" foreground="'..(beautiful.taglist_fg_focus or beautiful.fg_focus or "")..'" underline="single">%s</span>')
	return self.textClock
end

-- TaskList
function WidgetManager:getTaskBox(screen, is_vertical)
	-- TODO: These need to be seperate per screen, therefore I need a list for each, ie. WidgetManager.verticalTaskBoxes, WidgetManager.horizontalTaskBoxes
	local buttons = awful.util.table.join(
		awful.button({}, 1, toggleClient),
		awful.button({}, 3, function() toggleWibox(infoWibox) end)--toggleClientsList)
	)
	if is_vertical then
		local layout = wibox.layout.flex.vertical()
		local widget = awful.widget.tasklist(screen, awful.widget.tasklist.filter.allscreen, buttons, nil, nil, layout) -- Vertical 
		-- layout:fit_widget(widget, 100, 100)
		layout:fit(100, 100)
		widget:fit(100, 100)
		-- widget = awful.widget.layoutbox(screen)
		-- notify_send(inspect(layout, 2))
		-- notify_send(inspect(widget, 2))
		return widget
	else
		return awful.widget.tasklist(screen, awful.widget.tasklist.filter.currenttags, buttons) -- Normal
		-- allscreen,  All on Screen, Normal
	end
end

function WidgetManager:getInfoWibox(s, widget)
	local screenDimens = screen[s].workarea
	local aWibox = wibox({position = "left", screen = s, width = 300, height = screenDimens.height, y = screenDimens.y}) -- TODO: on task list change it should update height, never more than workarea
	aWibox:set_widget(widget)
	aWibox.ontop = true
	-- Start Hidden
	aWibox.visible = false
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
		-- awful.button({}, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end), -- Scroll To Switch Tags
		-- awful.button({}, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
	)

	--TagList
	-- TODO: CHange so it stores the tagsList for all screens
	-- self.tagsList = awful.widget.taglist(screen, awful.widget.taglist.filter.all, buttons)
	self.tagsList = awful.widget.taglist(screen, awful.widget.taglist.filter.noempty, buttons)
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
function WidgetManager:getNetUsage()
	-- TODO: Make some changes
	self.netwidget = wibox.widget.textbox()
	vicious.register(self.netwidget, vicious.widgets.net, '<span foreground="#97D599" weight="bold">↑${'..WidgetManager.wifiDevice..' up_kb}</span> <span foreground="#CE5666" weight="bold">↓${'..WidgetManager.wifiDevice..' down_kb}</span>  ', 1) --#585656
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
	function customWrapper(...) -- format, warg

		local retval = vicious.widgets.bat(...)
		local batteryPercent = retval[2]
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
	vicious.register(self.battery, customWrapper, '<span foreground="#ffcc00" weight="bold"> $1$2% $3</span>  ', 120, "BAT1") --585656
	self.battery.bg = "#cac6ce"
	
	return self.battery
end

return WidgetManager