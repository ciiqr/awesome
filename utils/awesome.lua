-- Description:
--		Functions & Functionality that should be provided automatically by awesome (IMO)

-- Imports

-- Errors --
------------
-- Startup (Only if this is the fallback config)
if awesome.startup_errors then
	naughty.notify({preset = naughty.config.presets.critical, title = "Errors Occured During Startup!", text = awesome.startup_errors})
end
-- Runtime
do
	local in_error = false
	awesome.connect_signal("debug::error", function(err)
		if in_error then return end -- Prevent Endless Error Loop
		in_error = true
		naughty.notify({ preset = naughty.config.presets.critical, title = "Errors Occurred", text = err })
		in_error = false
	end)
end

-- Functions --
---------------

-- Programs
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
			programName = basename(match)
			break
		end
	end
	-- VERY useful for Debugging
	-- notify_send(prg .. "\n" .. programName)

	-- checks if program is running
		-- if program is root then checks root, otherwise checks current user
	-- if it's not running then run it
	awful.util.spawn_with_shell(COMMAND_IS_RUNNING.." "..programName.." "..ternary(isRoot, "root", "$USER").." || ("..prg..")")
end

-- Mouse
function moveMouse(x_co, y_co)
    mouse.coords({ x=x_co, y=y_co })
end

-- Clients
function minimizeClient(c)
	-- Prevents Windows Being Minimized if they aren't on the task bar
	if not c.skip_taskbar then
		-- Minimize
		c.minimized = true
	end
end
function restoreClient()
	local c = awful.client.restore()
	-- Ensure unminimized client is the new focused client
	if c then
		client.focus = c
	end
end
function toggleClient(c)
  if c == client.focus then
	c.minimized = true
  else
	c.minimized = false
	if not c:isvisible() then
		awful.tag.viewonly(c:tags()[1])
	end
	client.focus = c
  end
end
function moveClientToTagAndFollow(tagNum, c)
	local c = c or client.focus
	if c then
		-- All tags on the screen
		local tags = awful.tag.gettags(c.screen)
		-- Index of tag
		local index
		if tagNum == -1 then
			index = #tags
		else
			index = tagNum
		end
		-- Get Tag
		local tag = tags[index]
		if tag then
			-- Move Window
			awful.client.movetotag(tag)
			-- Show Tag
			awful.tag.viewonly(tag)
		end
	end
end
function moveClientToFirstTagAndFollow(c)
	moveClientToTagAndFollow(1, c)
end
function moveClientToLastTagAndFollow(c)
	moveClientToTagAndFollow(-1, c)
end
-- TODO: Maybe think of a clean way to modularize below 2, would be nice to use moveClientToTagAndFollow
function moveClientLeftAndFollow(c)
	local tags = awful.tag.gettags(client.focus.screen)
	local curidx = awful.tag.getidx()
	local tag
	if curidx == 1 then
		tag = tags[#tags]
	else
		tag = tags[curidx - 1]
	end
	awful.client.movetotag(tag)
	--Follow
	awful.tag.viewonly(tag)
end
function moveClientRightAndFollow(c)
	local tags = awful.tag.gettags(client.focus.screen)
	local curidx = awful.tag.getidx()
	local tag
	if curidx == #tags then
		tag = tags[1]
	else
		tag = tags[curidx + 1]
	end
	--Move
	awful.client.movetotag(tag)
	--Follow
	awful.tag.viewonly(tag)
end
function toggleClientFullscreen(c)
	c.fullscreen = not c.fullscreen
end
function toggleClientTag(tagNum)
	local tag = awful.tag.gettags(client.focus.screen)[tagNum]
	if client.focus and tag then
		awful.client.toggletag(tag)
	end
end
switchClient = awful.client.focus.byidx

-- Tags
function toggleTag(tagNum)
	local tag = awful.tag.gettags(mouse.screen)[tagNum]
	if tag then
		awful.tag.viewtoggle(tag)
	end
end
function switchToTag(tagNum)
	local tag = awful.tag.gettags(mouse.screen)[tagNum]
	if tag then
		awful.tag.viewonly(tag)
	end
end
function switchToLastTag()
	local tags = awful.tag.gettags(mouse.screen)
	local tag = tags[#tags]
	if tag then
		awful.tag.viewonly(tag)
	end
	return tag
end
function switchToFirstTag()
	local tags = awful.tag.gettags(mouse.screen)
	local tag = tags[1]
	if tag then
		awful.tag.viewonly(tag)
	end
	return tag
end
function increaseMwfact(add, t)
	local new_mwfact = awful.tag.getmwfact(t) + add
	-- Only change the mwfact if it's not going to make things invisible
    if new_mwfact < 1 and new_mwfact > 0 then
    	awful.tag.incmwfact(add, t)
    end
end

-- Wibox
function toggleWibox(wibox, s)
	local s = s or mouse.screen
	local lwibox = wibox[s]
	lwibox.visible = not lwibox.visible
	
	-- Adjust the infoWibox's height when the top/bottom wiboxes are resized
	-- TODO: Move this to the signal handler for "property::visible"
	-- OR more reasonably "property::workarea" of the screen
	local position = awful.wibox.get_position(lwibox)
	if position == "top" or position == "bottom" then
		
		infoWibox[s].y = screen[s].workarea.y
		infoWibox[s].height = screen[s].workarea.height
	end
end
