local preMaximizeLayouts = {}
for s = 1, screen.count() do
	preMaximizeLayouts[s] = {}
end

--TaskBox
function toggleClient(c)
  if c == client.focus then
	c.minimized = true
  else
	c.minimized = false
	if not c:isvisible() then
		awful.tag.viewonly(c:tags()[1])
	end
	client.focus = c
	c:raise()
  end
end

--Keys
--Global
function goToLastTag(...)
	local screen = mouse.screen
	local tag = awful.tag.gettags(screen)[9]
	if tag then
		awful.tag.viewonly(tag)
	end
end
function goToFirstTag(...)
	local screen = mouse.screen
	local tag = awful.tag.gettags(screen)[1]
	if tag then
		awful.tag.viewonly(tag)
	end
end

-- Layout
function switchWindow(direction)
	awful.client.focus.byidx(direction)
	if client.focus then
		client.focus:raise()
	end
end
function maximizeLayout()
	-- If No Layout Stored Then
	if (not preMaximizeLayouts[mouse.screen][awful.tag.selected()]) then
		-- Store Current Layout
		preMaximizeLayouts[mouse.screen][awful.tag.selected()] = awful.layout.get(mouse.screen)
		-- Change to Maximized
		awful.layout.set(awful.layout.suit.max)
	end
end
function revertMaximizeLayout()
	-- Revert Maximize
	if (awful.layout.get(mouse.screen) == awful.layout.suit.max) then
		awful.layout.set(preMaximizeLayouts[mouse.screen][awful.tag.selected()])
		-- Nil so it is garbage collected
		preMaximizeLayouts[mouse.screen][awful.tag.selected()] = nil
	end
end
function goToLayout(direction) -- -1 for back, 1 for forward 
	-- if maximized to go first layout
	if awful.layout.get(mouse.screen) == awful.layout.suit.max then
		awful.layout.set(layouts[direction])
		-- Clear Maximized Layout
		preMaximizeLayouts[mouse.screen][awful.tag.selected()] = nil
	else
		awful.layout.inc(layouts, direction)
	end
end

--Tags
function toggleClientTag(tagNum)
	local tag = awful.tag.gettags(client.focus.screen)[tagNum]
	if client.focus and tag then
		awful.client.toggletag(tag)
	end
end
function moveClientToTag(tagNum)
	if not client.focus then return end
	local tag = awful.tag.gettags(client.focus.screen)[tagNum]
	if client.focus and tag then
		awful.client.movetotag(tag) -- Move Window to tag

		awful.tag.viewonly(tag) -- Show Tag
	end
end
function toggleTag(tagNum)
	local tag = awful.tag.gettags(mouse.screen)[tagNum]
	if tag then
		awful.tag.viewtoggle(tag)
	end
end
function viewOnlyTag(tagNum)
	local tag = awful.tag.gettags(mouse.screen)[tagNum]
	if tag then
		awful.tag.viewonly(tag)
	end
end

--Client
function minimizeClient(c)
	-- Prevents Windows Being Minimized if they arn't on the task bar
	if c.skip_taskbar then
		return
	end
	-- The client currently has the input focus, so it cannot be
	-- minimized, since minimized clients can't have the focus.
	c.minimized = true
end
function restoreClient()
	local c = awful.client.restore()
	if c then
		client.focus = c
		c:raise()
	end
end
function moveClientLeftAndFollow(c)
	local curidx = awful.tag.getidx()
	local tag
	if curidx == 1 then
		tag = tags[client.focus.screen][9]
	else
		tag = tags[client.focus.screen][curidx - 1]
	end
	awful.client.movetotag(tag)
	--Follow
	awful.tag.viewonly(tag)
end
function moveClientRightAndFollow(c)
	local curidx = awful.tag.getidx()
	local tag
	if curidx == 9 then
		tag = tags[client.focus.screen][1]
	else
		tag = tags[client.focus.screen][curidx + 1]
	end
	awful.client.movetotag(tag)
	--Follow
	awful.tag.viewonly(tag)
end
function moveClientToTagAndFollow(tagNum)
	if client.focus then
		local tag = awful.tag.gettags(client.focus.screen)[tagNum]
		if tag then
			awful.client.movetotag(tag) -- Move Window to tag

			awful.tag.viewonly(tag) -- Show Tag
		end
	end
end
function titleBarEnabledForClient(c)
	if c.class == "Plugin-container" then
		return false
	elseif c.class == "XTerm" then
		return false
	end
	return true
end
function toggleTitleBar(c)
	if awful.titlebar(c).visible == true then
		awful.titlebar(c).visible = false
		awful.titlebar(c, {size = 0})
	else
		addTitlebarToClient(c)
		awful.titlebar(c).visible = true
		-- awful.titlebar(c)
	end
end
function addTitlebarToClient(c)
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
	
	awful.titlebar(c):set_widget(layout)
	awful.titlebar(c).visible = true
end
function MultiFullScreen(c)
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

function moveMouse(x_co, y_co)
    mouse.coords({ x=x_co, y=y_co })
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
	local titlebars_enabled = false
	if titlebars_enabled and (c.type == "normal") and titleBarEnabledForClient(c) then -- or c.type == "dialog"
		addTitlebarToClient(c)
	end
end
function run_once(prg)

	local programName
	local isRoot = false -- if its root then we must check the root user instead, only problem is if i'm also running root
	-- Itterate matches
		-- if its not sudo then you've found the program name
		-- break from the loop
	for match in string.gmatch(prg, "([^ ]+)") do
		if match == "sudo" then
			isRoot = true
		else
			programName = match
			break
		end
	end
	-- wvprint(prg .. "\n" .. programName)

	-- checks if program is running
		-- if program is root then checks root, otherwise checks current user
	-- if it's not running then run it
	awful.util.spawn_with_shell("pgrep -u "..ternary(isRoot, "root", "$USER" ).." -x "..programName.." || ("..prg..")")
end
function ternary(condition, tVal, fVal)
  if condition then return tVal else return fVal end
end

-- Split String
function split(str, pat)
   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
	 table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end

function moveMouse(x_co, y_co)
    mouse.coords({ x=x_co, y=y_co })
end

function toggleWibox(wibox)
	local lwibox = wibox[mouse.screen]
	lwibox.visible = not lwibox.visible
end

function putToSleep()
	local screenDimens = screen[mouse.screen].workarea
	moveMouse(screenDimens.width / 2, screenDimens.height / 2)
	awful.util.spawn(COMMAND_SLEEP)
end

--Naughty
function wvprint(text, timeout)
	naughty.notify({preset = naughty.config.presets.normal, text = text, screen = screen.count(), timeout = timeout or 0})
end
function debug_editor(object, recursion, editor)
	return awful.util.spawn_with_shell("echo \""..inspect(object, recursion or 1).."\" | "..editor)
end
function debug_leaf(object, recursion)
	return debug_editor(object, recursion, "leafpad")
end
function debug_subl(object, recursion)
	return debug_editor(object, recursion, "subl3 -n")
end

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