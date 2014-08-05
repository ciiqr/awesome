-- Awesome Window Manager Configuration --
------------------------------------------
-- Author:			William Villeneuve	--
-- Date Modified:	  August 4, 2014	--
--------------------------------------------------------------------------------------
-- Description:	This is the main file for my awesome configuration. I have put a	--
-- large focus on cleaning up this file and modularizing different aspects of it.	--
-- Some of the more interesting aspects are: a seperate key binding for going into	--
-- out of the maximized layout, this means that the maximized layout is not in my	--
-- layouts array and that some midifications are necessary to the switch layout		--
-- function so that it can get you out of maximized. When maximizing, the current	--
-- layout for the given tag/screen is saved and upon demaximizing it is restored to	--
-- that layout. Displays Configure time in milliseconds on startup/restart. Few		--
-- inline functions (Declared at the top or in seperate files). Many Constants.		--
-- Toggle-able wiboxes. Widgets for: ip address, temperature, network usage,		--
-- battery level & charge state, volume (with keybindings for course & fine			--
-- adjustment), memory usage, cpu graph, time w/ popup-calendar. Special toggleable	--
-- side wibox (W.I.P.) which will display additional information which shouldn't be	--
-- on the main wiboxes (Currently just a custom minimalist clock). Selection		--
-- screenshots. Default mouse location on startup, Seperate module for creation of	--
-- widgets. Window debug information (useful for creation of rules). Toggle-able	--
-- titlebar which is disabled by default.											--
-- NOTE: I use this configuration on a 1920x1080 15" screen, you may need to adjust	--
--		certain aspects to fit well with your screen & theme.						--
-- Overall it is a great work in progress, it is perfect for day to day use and  	--
-- suits my needs well. Feel free to use any code within, in your own configuration --
-- DFTBA Everyone!																	--
--------------------------------------------------------------------------------------
-- Bugs:																			--
-- - Modules like ColorDisplayWidget do not create new instaces if required again.	--
--------------------------------------------------------------------------------------
-- Required:																		--
-- xterm, sublime text(subl3), systemd(systemctl), scrot, import, python2, xdg-open --
--------------------------------------------------------------------------------------

-- Include --
-------------
-- Standard
gears		= require("gears")
awful		= require("awful")
awful.rules	= require("awful.rules")
			  require("awful.autofocus")
			  require("awful.remote")
wibox		= require("wibox")
beautiful 	= require("beautiful"); 
naughty		= require("naughty")
-- Config
require("declarations")
if DEBUG then inspect = require("inspect") end
xrandr		= require("utils.xrandr")
			  require("utils.lua")
			  require("utils.awesome")
			  require("utils.config")
-- Beautiful Theme
beautiful.init(THEME_PATH)

-- Variables --
---------------
--Model
layouts=nil -- Global, Required
local globalKeys -- Setup
local clientKeys -- Setup
local clientButtons -- Setup
--Visual
tWibox={} -- Persistent
bWibox={} -- Persistent
infoWibox={} -- Persistent
local name_callback = {}  -- Persistent
--Widgets
local widget_manager = require("WidgetManager")

-- Setup --
-----------
--Layouts
layouts = {
	awful.layout.suit.tile
	,awful.layout.suit.fair
	,awful.layout.suit.fair.horizontal
}

-- Per-Screen Setup (Wallpapers, Tags, Pop-down Terminal/Htop/Note, Maximized Layouts, Top/BottomBars)
for s = 1, screen.count() do
	local top_layout	= wibox.layout.align.horizontal()
	local left_layout	= wibox.layout.fixed.horizontal()
	local middle_layout	= wibox.layout.flex.horizontal()
	local right_layout	= wibox.layout.fixed.horizontal()
	local bottomLayout	= wibox.layout.align.horizontal()
	local infoLayout	= wibox.layout.flex.vertical()
	
	--Wallpapers
	if beautiful.wallpaper then
		gears.wallpaper.maximized(beautiful.wallpaper, s, true)
	end
	
	--Tags
	local tileLay = layouts[1]
	awful.tag(SCREEN_TAGS, s, {layouts[2], tileLay, tileLay, tileLay, tileLay, tileLay, tileLay, tileLay, tileLay}) 

	-- Popup Terminal/Process Info/Notes
	widget_manager:initPopupTerminal(s)
	widget_manager:initPopupCPU(s)
	widget_manager:initPopupMemory(s)
	widget_manager:initPopupNotes(s)


	--Wiboxes w/ Widgets
	--Left Widgets
	-- Main Menu Button
	if s == 1
		then left_layout:add(widget_manager:getMainMenuButton())
	end
	-- Tag List
	left_layout:add(widget_manager:getTagsList(s))

	--Middle Widget
	-- IP
	middle_layout:add(widget_manager:getIP())

	--Right Widgets
	if s == screen.count() then -- Main Widgets on Far Right
		-- Moon
		-- right_layout:add(require("moonPhase"):init())
		-- Test Widget
		-- right_layout:add(require("testWidget"):init())
		
		-- Temperature
		right_layout:add(widget_manager:getTemperature())
		-- Net Usage
		right_layout:add(widget_manager:getNetUsage())
		-- Battery Widget
		if IS_LAPTOP then
			right_layout:add(widget_manager:getBatteryWidget())
		end
		-- Volume
		right_layout:add(widget_manager:getVolume())
		--Memory
		right_layout:add(widget_manager:getMemory())
		--CPU
		right_layout:add(widget_manager:getCPU())
		-- System Tray
		right_layout:add(widget_manager:getSystemTray())
		-- Clock
		right_layout:add(widget_manager:getTextClock())
	end

	-- Layout Box
	right_layout:add(widget_manager:getLayoutBox(s))

	--Add Layouts to Master Layout & Set tWibox Widget to Master Layout
	top_layout:set_left(left_layout)
	top_layout:set_middle(middle_layout)
	top_layout:set_right(right_layout)

	--tWibox
	tWibox[s] = awful.wibox({position = "top", screen = s, height = 22})
	tWibox[s]:set_widget(top_layout)

	-- Wibox Buttons
	if DEBUG then
		tWibox[s]._drawable.widget:buttons(awful.util.table.join(
			awful.button({SUPER}, 1, function() tWibox[s]:geometry({height = 22}) end),
			awful.button({SUPER}, 3, function() tWibox[s]:geometry({height = 100}) end)
		))
	end
	
	-- Task List
	bottomLayout:set_middle(widget_manager:getTaskBox(s))
	--bWibox
	bWibox[s] = awful.wibox({position = "bottom", screen = s, height = 22})
	bWibox[s]:set_widget(bottomLayout)


	-- Info Wibox Layout
	-- Info Widgets & Time
	-- infoLayout:set_first(require("awedock"):init())
	-- infoLayout:set_middle(require("ColorDisplayWidget"):init({"5A667F", "b0d54e", "5f8787", "69b2b2", "FF0000", "de5705", "00ff00"})) -- This overrides the previous
	infoLayout:add(widget_manager:getTaskBox(s, true))

	-- Info Wibox
	infoWibox[s] = widget_manager:getInfoWibox(s, infoLayout)
end

--Global Key Bindings
globalKeys = awful.util.table.join(
	--Switch Between Tags
	awful.key({SUPER}, "Escape", awful.tag.history.restore),
	awful.key({ALT, CONTROL}, "Left", awful.tag.viewprev),
	awful.key({ALT, CONTROL}, "Right", awful.tag.viewnext),
	awful.key({ALT, CONTROL}, "Up", switchToFirstTag),
	awful.key({ALT, CONTROL}, "Down", switchToLastTag),

	--Toggle Bars
	awful.key({SUPER}, "[", function() toggleWibox(tWibox); toggleWibox(bWibox) end),
	awful.key({SUPER}, "]", function() toggleWibox(bWibox) end),
	awful.key({SUPER}, "c", function() toggleWibox(infoWibox) end),

	--Modify Layout (NOTE: never use)
	awful.key({SUPER, SHIFT}, "h", function() awful.tag.incnmaster(1) end),
	awful.key({SUPER, SHIFT}, "l", function() awful.tag.incnmaster(-1) end),

	--Switch Layout
	awful.key({SUPER}, "space", function() goToLayout(1) end),
	awful.key({SUPER, SHIFT}, "space", function() goToLayout(-1) end),

	--Swtich Window
	awful.key({SUPER}, "Tab", function() switchClient(1) end),
	awful.key({SUPER, SHIFT}, "Tab", function() switchClient(-1) end),
	-- Alternatively With Page Up/Down
	awful.key({SUPER}, "Next", function() switchClient(1) end),
	awful.key({SUPER}, "Prior", function() switchClient(-1) end),
	
	--ClientRestore
	awful.key({SUPER, CONTROL}, "Up", restoreClient),

	--Maximize
	awful.key({SUPER}, "Up", switchToMaximizedLayout),
	--Revert Maximize
	awful.key({SUPER}, "Down", revertFromMaximizedLayout),
	
	--Sleep
	awful.key({}, "XF86Sleep", putToSleep),

	-- Add Tag
	awful.key({SUPER}, "y", function()
		-- Add Tag
		newTag = awful.tag.add("Tag "..(#awful.tag.gettags(mouse.screen)) + 1)
		-- Switch to it
		awful.tag.viewonly(newTag)
	end),
	
	-- Remove Tags
	awful.key({SUPER, SHIFT}, "y", function()
		local selectedTags = awful.tag.selectedlist(mouse.screen)
		for tag, _ in pairs(selectedTags) do
			awful.tag.delete(_, tag)
		end
	end),
	
	--Change Position (NOTE: never use)
	awful.key({SUPER}, "Left",	function() awful.client.swap.bydirection("left") end), 
	awful.key({SUPER}, "Right",function() awful.client.swap.bydirection("right") end),
	-- awful.key({SUPER, CONTROL}, "Up",	function() awful.client.swap.bydirection("up") end), 
	-- awful.key({SUPER, CONTROL}, "Down",	function() awful.client.swap.bydirection("down") end),

	--Move Middle
	-- awful.key({SUPER}, "l", function() awful.tag.incmwfact(0.05) end),
	-- awful.key({SUPER}, "h", function() awful.tag.incmwfact(-0.05) end),

	--Change Number of Columns(Only on splitup side)
	-- awful.key({SUPER, CONTROL}, "h", function() awful.tag.incncol( 1) end),
	-- awful.key({SUPER, CONTROL}, "l", function() awful.tag.incncol(-1) end),
	
	-- Switch beteen screens
	-- TODO: Make it depend on the number of attached screens
	awful.key({SUPER}, "F1", function () awful.screen.focus(1) end),
	awful.key({SUPER}, "F2", function () awful.screen.focus(2) end),

	--Popups
	awful.key({SUPER}, "w", function() widget_manager.mainMenu:show({coords = {x = 1, y = 1}}) end),
	awful.key({SUPER}, "p", function() awful.util.spawn_with_shell(string.format(COMMAND_LAUNCHER, screen[mouse.screen].workarea.y)) end),
	awful.key({SUPER}, "o", function() awful.util.spawn_with_shell(string.format(COMMAND_FILE_OPENER, screen[mouse.screen].workarea.y)) end),
	-- Terminal
	awful.key({SUPER, SHIFT}, "t", function() widget_manager:togglePopupTerminal() end),
	-- Quick Note
	awful.key({SUPER, SHIFT}, "n", function() widget_manager:togglePopupNotes() end),
	-- Htop
	awful.key({SUPER, SHIFT}, "c", function() widget_manager:togglePopupCPU() end),
	awful.key({SUPER, SHIFT}, "m", function() widget_manager:togglePopupMemory() end),

	--Programs
	-- Terminal
	awful.key({SUPER}, "t", function() awful.util.spawn(TERMINAL) end),
	
	-- File Manager
	awful.key({SUPER}, "Return", function() awful.util.spawn(FILE_MANAGER) end),
	awful.key({SUPER, SHIFT}, "Return", function() awful.util.spawn("sudo "..FILE_MANAGER) end),

	--Awesome
	awful.key({SUPER, CONTROL}, "r", awesome.restart),
	-- NOTE: never use
	-- awful.key({SUPER, SHIFT}, "q", awesome.quit),

	--System
	--Volume
	awful.key({}, "XF86AudioLowerVolume", function() widget_manager:changeVolume("-") end),
	awful.key({}, "XF86AudioRaiseVolume", function() widget_manager:changeVolume("+") end),
	awful.key({SHIFT}, "XF86AudioLowerVolume", function() widget_manager:changeVolume("-", VOLUME_CHANGE_SMALL) end),
	awful.key({SHIFT}, "XF86AudioRaiseVolume", function() widget_manager:changeVolume("+", VOLUME_CHANGE_SMALL) end),

	--Brightness
	awful.key({}, "XF86MonBrightnessUp", function() changeBrightness("+", BRIGHTNESS_CHANGE_NORMAL) end),
	awful.key({}, "XF86MonBrightnessDown", function() changeBrightness("-", BRIGHTNESS_CHANGE_NORMAL) end),
	awful.key({SHIFT}, "XF86MonBrightnessUp", function() changeBrightness("+", BRIGHTNESS_CHANGE_SMALL) end),
	awful.key({SHIFT}, "XF86MonBrightnessDown", function() changeBrightness("-", BRIGHTNESS_CHANGE_SMALL) end),
	
	--Invert Screen
	awful.key({SUPER}, "i", function() awful.util.spawn_with_shell(COMMAND_SCREEN_INVERT) end),
	
	--PrintScreen
	awful.key({}, "Print", captureScreenShot),

	--PrintScreen (Select Area)
	awful.key({SUPER}, "Print", captureScreenSnip),

	--Cycle Displays
	awful.key({SUPER}, "F11", xrandr),
	
	-- Pasteboard paste
	awful.key({}, "Insert", function() notify_send("Insert", 0.5) ;awful.util.spawn("xdotool click 2") end) -- put 'keycode 118 = ' back in .Xmodmap if I no longer use this

	--Switch Focus
	-- awful.key({SUPER}, "j",
	--  function()
	--	awful.client.focus.byidx( 1)
	--  end),
	-- awful.key({ SUPER,		   }, "k",
	--  function()
	--	awful.client.focus.byidx(-1)
	--  end),

	-- -- Run or raise applications with dmenu
	-- ,awful.key({SUPER, CONTROL}, "p", function()
	-- 	local f_reader = io.popen( "dmenu_run | dmenu -b -nb '".. beautiful.bg_normal .."' -nf '".. beautiful.fg_normal .."' -sb '#955'")
	-- 	local command = assert(f_reader:read('*a'))
	-- 	f_reader:close()
	-- 	if command == "" then return end

	-- 	-- Check throught the clients if the class match the command
	-- 	local lower_command=string.lower(command)
	-- 	for k, c in pairs(client.get()) do
	-- 		local class=string.lower(c.class)
	-- 		if string.match(class, lower_command) then
	-- 			for i, v in ipairs(c:tags()) do
	-- 				awful.tag.viewonly(v)
	-- 				c.minimized = false
	-- 				return
	-- 			end
	-- 		end
	-- 	end
	-- 	awful.util.spawn(command)
	-- end)
)
--Tag Keys
-- Uses keycodes to make it works on any keyboard layout
local numberOfTags = #(awful.tag.gettags(mouse.screen))
for i = 1, numberOfTags do
	local iKey = "#"..(i + numberOfTags)
	globalKeys = awful.util.table.join(globalKeys,
		awful.key({ALT, CONTROL},		iKey, function() switchToTag(i) end),
		awful.key({SUPER, ALT},			iKey, function() moveClientToTagAndFollow(i) end),
		
		-- NOTE: Never Used
		awful.key({SUPER, SHIFT},		iKey, function() toggleTag(i) end),
		awful.key({SUPER, CONTROL, ALT},iKey, function() toggleClientTag(i) end)) -- TODO: Change to Control, Alt Shift to be more like mod shift for toggleing a tag visibility
end

--Set Global Keys
root.keys(globalKeys) -- root.keys(musicwidget:append_global_keys(globalKeys))

--Client
--Keys
clientkeys = awful.util.table.join(
	-- Move Between Tags
	awful.key({SUPER, ALT}, "Left", moveClientLeftAndFollow),
	awful.key({SUPER, ALT}, "Right", moveClientRightAndFollow),
	awful.key({SUPER, ALT}, "Up", moveClientToFirstTagAndFollow),
	awful.key({SUPER, ALT}, "Down", moveClientToLastTagAndFollow),
	--Kill
	awful.key({SUPER}, "q", function(c) c:kill() end),

	--Fullscreen
	awful.key({SUPER}, "f", toggleClientFullscreen),
	
	-- Multi Fullscreen
	awful.key({SUPER, SHIFT}, "f", toggleClientMultiFullscreen),

	--Minimize
	awful.key({SUPER, CONTROL}, "Down", minimizeClient),

	--Toggle Titlebar
	awful.key({SUPER, ALT}, "[", toggleClientTitlebar)

	--Floating
	,awful.key({SUPER, ALT}, "space", awful.client.floating.toggle)
	
	--Debug Info (F12)
	,awful.key({SUPER}, "g", ternary(DEBUG, debugClient, function()end))
)
--Buttons
clientButtons = awful.util.table.join(
	awful.button({}, 1, function(c) client.focus = c; c:raise() end),-- Click Focuses & Raises
	awful.button({SUPER}, 1, awful.mouse.client.move),				 -- Super + Left Moves
	awful.button({SUPER}, 3, awful.mouse.client.resize)				 -- Super + Right Resizes
)

--Rules
awful.rules.rules = {
	{
		rule = {},
		properties = {
			-- Border
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			-- Focus
			focus = awful.client.focus.filter,
			-- Interaction
			keys = clientkeys,
			buttons = clientButtons,
			-- Prevent Clients Maximized on Start
			maximized_vertical   = false,
 			maximized_horizontal = false
		}
	}
	,{ -- Floating
		rule_any = {
			class = {"Speedcrunch", "pinentry", "MPlayer", "Plugin-container", "Exe", "Gtimer", "Vmware-modconfig", "freerdp", "Seafile-applet", "Pavucontrol", "mainframe", "Redshiftgui"},
			name = {"Tab Organizer"},
			type = {"dialog"},
			role = {"pop-up"}
		},
		properties = {
			floating = true
		}
	}
	,{ -- Ignore Size Hints
		rule_any = {
			name = {"FrostWire", "MonoDevelop", "7zFM", "Vmware"},
			class = {"XTerm", "Ghb"}
		},
		properties = {
			size_hints_honor = false
		}
	}
	,{
		rule = {
			class = "XTerm"
		},
		properties = {
			opacity = 0.8
		}
	}
	,{
		rule = {
			class = "Spacefm",
			name = "Choose An Application"
		},
		properties = {
			callback = function(c) c:geometry({width = 500, height = 600}) end
		},
	}
	,{
		rule = {
			class = "Google-chrome"
		},
		rule_any = {
			name = {"Edit Bookmark", "Bookmark All Tabs"}
		},
		except_any = {
			name = {"Save File", "Open Files"}
		},
		properties = {
			callback = function(c) c:geometry({width = 350, height = 950, y = 65}) end
		},
	}
	,{
		rule_any = {
			class = {"Google-chrome-stable", "Google-chrome-unstable"},
			name = {"Untitled"} -- All Extension Windows
		},
		properties = {
			callback = function(c)
				-- Function to recheck name
				name_callback[c] = function(c)
					if c.name then
						-- Check what the new name is
						if string.find(c.name, "Tab Organizer") then -- Properties
							-- Set Floating
							awful.client.floating.set(c, true)
							-- Set Ontop
							-- Change Size
							local screenDimens = screen[mouse.screen].workarea
							local screenHeight = screenDimens.height
							c:geometry({width = screenDimens.width - (2 * beautiful.border_width), height = screenHeight / 2, y = screenHeight/  4, x=0})


						elseif string.find(c.name, "Select the email service you use") then -- Properties
							-- Set Floating
							awful.client.floating.set(c, true)
						else
							-- Print Name So I Can Possibly Change Other Names
							-- notify_send(tostring(c.name or "nil"), 2)
						end
						-- Clear Client From Callback Array
						name_callback[c] = nil
					end
				end
				-- Connect Function
				c:connect_signal("property::name", name_callback[c])
			end
		},
	}
	,{
		rule = {
			class = "Subl3",
			type = "dialog"
		},
		except_any = {
			name = {
				"O", "S", "E"
			}
		},
		properties = {
			callback = function(c)
				if c:geometry().width == 451 or c:geometry().width == 490 then
					c:kill();
				end
				notify_send("Sublime\nHis name was Robert.. Oh I Mean '".. (c.name or "nil") .."'", 3);
			end --c:geometry()
		}
	}
	,{
		rule = {
			class = "Subl3"
		},
		except_any = {
			type = {
				"dialog"
			}
		},
		properties = {
			switchtotag = true
			,callback = function(c)
				local targetTag = nil
				-- Client Info
				local clientScreen = c.screen
				local clientName = c.name

				if clientName then
					-- Get Tags
					local tags = awful.tag.gettags(clientScreen)
					
					-- Determine Tag
					if clientName:find("%(QuickLaunch%)") or clientName:find("%(Dame%)") then
						targetTag = tags[2]
						
					elseif clientName:find("%(Random%)") then
						targetTag = tags[3]
						
					elseif clientName:find("%(Dame, Testing%)") then
						targetTag = tags[2]
						
					-- elseif clientName:find("%(Website%)") then
					-- 	targetTag = tags[5]

					-- elseif clientName:find("%(School%)") then
					-- 	targetTag = tags[6]

					elseif clientName:find("%(.awesome%)") then
						targetTag = tags[7]

					end

					-- Move client to tag
					if targetTag then
						awful.client.toggletag(targetTag, c)
					end
				end
			end
		}
	
	}
	,{
		rule = {
			class = "Seafile-applet",
			type = "normal"
		},
		properties = {
			border_width = 0,
			callback = function(c)
				-- existingDimens = c:geometry()
				screenDimens = screen[mouse.screen].workarea
				local width = 302
				local height = 883
				c:geometry({
					x = screenDimens.width - width,
					y = screenDimens.y,
					width = width,
					height = height
				})
			end
		}
	}
	,{
		rule = {
			class = "Pavucontrol"
		},
		properties = {
			callback = function(c)
				local existingDimens = c:geometry()
				screenDimens = screen[mouse.screen].workarea
				local width = existingDimens.width
				local height = existingDimens.height
				c:geometry({
					x = screenDimens.width - width,
					y = screenDimens.y,
					width = width,
					height = height
				})
			end
		}
	}
	,{
		rule = {
			name = "PlayOnLinux Warning"
		},
		properties = {
			callback = function(c) c:kill() end
		}
	}
	,{
		rule = {
			class = "Skype",

		},
		properties = {
			-- callback = function(c)
			-- 	-- Floating Windows have a north west gravity, others have static
			-- 	-- False Assumption
			-- 	-- if c.size_hints.win_gravity == "north_west" then
			-- 	-- 	awful.client.floating.set(c, true)
			-- 	-- end
			-- end,
			size_hints_honor = false
		}
	}
	,{
		rule = {
			class = "Plugin-container"
		},
		properties = {
			callback=function(c) c.fullscreen = true end
		}
	}
	,{
		rule = {
			class = "Vmware"
		},
		properties = {
			tag = awful.tag.gettags(mouse.screen)[4]
		}
	}
	,{
		rule = {
			role = "GtkFileChooserDialog"
		},
		properties = {
			callback=  function(c)
				-- Change Size of Normal Window Only
				-- if c.type == "floating" then
					-- existingDimens = c:geometry()
					screenDimens = screen[mouse.screen].workarea
					local height = screenDimens.height * 0.75
					c:geometry({
						y = (screenDimens.height - height) / 2,
						width = screenDimens.width * 0.5,
						height = height
					})
				-- end
			end
		}
	}
	--,{
	--	rule = {
	--		class = "Eclipse"
	--	},
	--	properties = {
	--		tag = awful.tag.gettags[1][2]
	--	}
	--}
}

-- TODO: Move to config
--Signals
--Client
client.connect_signal("manage", manageClient)
-- Change Border Colours
-- Raise on focus
client.connect_signal("focus",	 function(c) c.border_color = beautiful.border_focus; c:raise() end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- Floating always means ontop
client.connect_signal("property::floating", function(c) c.ontop = awful.client.floating.get(c) end)
--Mouse Over Focus
client.connect_signal("mouse::enter", function(c)
	-- NOTE: Experimental support for not changing focus from transient back to it's parent
	-- NOTE: If there is anpther client on screen then we can still switch to that client then back to the parent...
	-- NOTE: ALSO: Experimental support for not changing focus to fullscreen windows automatically, intended to help with the fact that fullscreen windows are displayed over top of wiboxes
	if awful.client.focus.filter(c) and client.focus.transient_for ~= c and (not c.fullscreen) then --  and awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
			client.focus = c
	end
end)

-- Programs -- (run_once takes a while, probably due to system calls, try making a script that takes a list of files and runs them with the same commands as before)
--------------
for _,i in pairs(STARTUP_PROGRAMS) do
	run_once(i)
end

-- End Configuring --
---------------------
-- Move Mouse
moveMouse(100, 100)

-- Cleanup Variables --
-----------------------
THEME_NAME = nil
STARTUP_PROGRAMS = nil
EDITOR = nil

globalKeys = nil
clientKeys = nil
clientButtons = nil
START_TIME = nil
printEnd = nil