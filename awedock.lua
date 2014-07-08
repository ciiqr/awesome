--[[
-- Name:			testWidget
-- 
-- Author:			William A. Villeneuve
-- Date Created:	October 6, 2013
-- Date Modified:	October 6, 2013
-- 
-- Description:		A widget which will be added to a wibox within the Awesome Window Manager,
-- 					it is intended as a test platform for different ideas and as a learning tool.
--
-- Usage Notes:		Force a redraw with: testWidget:emit_signal("widget::updated")

-- Ideas:			2 circles with a piece missing, each going opposite directions, one inside the other, one white, the other clightly transparent red

--]]---------------------------------------------------------------------------------------------


-- Retrieve from globals if they exist or require if they don't
local gears = gears or require("gears")
local awful = awful or require('awful')
local wibox = wibox or require('wibox')
local math  = math  or require('math')

-- Utilities
local function toradians(degree)
	return (degree + 25.0) * (math.pi/180.0) - 90
end

-- Widget Instance
local testWidget = wibox.widget.base.make_widget()

-- Fields
testWidget.pressed = false

-- Methods
testWidget.fit = function(self, width, height)
	local size = math.min(width, height)
	return size - size/3, size
end

testWidget.draw = function(self, wibox, cr, width, height)
-- Text
	-- Properties
	-- local fontSize = 30.0
	-- cr:set_font_size(fontSize);

	-- cr:select_font_face("Sans", "NORMAL", "BOLD");


	-- cr:move_to(0, fontSize);
	-- cr:show_text("Hello");

	-- cr:move_to(0.0, fontSize * 2);
	-- cr:text_path("You ;)");

	-- cr:set_source_rgb(0.5, 0.5, 1);
	-- cr:fill_preserve(cr);

	-- -- void Border
	-- cr:set_source_rgb(1, 1, 1);
	-- cr:set_line_width(0.5);

	-- -- 
	-- cr:stroke(cr);

-- Background
	cr:save()
		cr:set_source_rgba(63/255, 63/255, 63/255, 1)
		cr:paint()
	cr:restore()
-- Arrow With 2 Colours, one will be background color, the other (the actual arrow) will be the other colour
	-- cr:set_line_width(7.5);
	-- local inset = 0--height / 10

	-- cr:move_to(inset, inset)
	-- cr:line_to(width - inset, height / 2)
	-- cr:line_to(inset, height - inset)
	-- cr:close_path()
	-- cr:set_line_join("ROUND") -- Only For Stroke
	-- cr:fill_preserve()
	-- if not inset == 0 then -- Dont Stroke because we want a normal triangle
	-- 	cr:stroke()
	-- end

-- Figure 8
	-- cr:set_line_width(10);
	-- cr:move_to(25, 30);
	-- cr:rel_line_to(20, -20);
	-- cr:rel_line_to(20, 20);
	-- cr:rel_line_to(-40, 40);
	-- cr:rel_line_to(20, 20);
	-- cr:rel_line_to(20, -20);
	-- cr:close_path()

	-- cr:set_line_join("ROUND");
	-- cr:stroke();


-- 3 Lines
	local xStart = width / 4
	local xEnd = width - xStart

	local firstY = height / 3
	local secondY = height / 2
	local thirdY = height - (height / 3)

	if self.pressed then
		cr:set_source_rgba(0, 0, 0, 1)
	end

	cr:move_to(xStart, firstY)
	cr:line_to(xEnd, firstY)

	cr:move_to(xStart, secondY)
	cr:line_to(xEnd, secondY)

	cr:move_to(xStart, thirdY)
	cr:line_to(xEnd, thirdY)

	cr:set_line_width(height / 10)
		cr:set_line_cap("ROUND")
	cr:stroke()

-- Clock
	-- local xc = width / 2
	-- local yc = height / 2
	-- local lineWidth = 2
	-- local radius = xc - lineWidth
	-- local degrees = (math.pi/180.0)
	-- local spacing = 2

	-- local angle1 = 45.0 * degrees
	-- local angle2 = 180.0 * degrees
	-- local beginningAngle = spacing * degrees
	-- local endAngle = (math.pi*2) - (spacing * degrees)

	-- -- Outside Circle (White)
	-- cr:set_line_width(lineWidth)
	-- cr:arc(xc, yc, radius, toradians(0), toradians((tonumber(os.date('%I'))/12 * 360)))
	-- cr:stroke()

	-- -- Change to Red
	-- cr:set_source_rgba(1, 0.2, 0.2, 0.6)
	-- cr:set_line_width(3) -- if height 100..6 if height 22..3

	-- -- Inner Circle
	-- -- cr:arc(xc, yc, height / 10, 0, 2*math.pi)
	-- -- cr:fill()

	-- -- Line 1
	-- local minutes = toradians((tonumber(os.date('%M'))/60.0 * 360.0))
	-- cr:arc(xc, yc, radius, minutes, minutes)
	-- cr:line_to(xc, yc)
	-- -- Line 2
	-- -- cr:arc(xc, yc, radius, angle2, angle2)
	-- -- cr:line_to(xc, yc)

	-- cr:stroke()
end

testWidget.init = function(self)
	-- for index = 1, #itemsInFolder do
	-- 	wvprint(inspect(io.read("R", "~/.FBReader"), 2))
	-- end

	return self
end

-- Signals
testWidget:connect_signal("mouse::enter",
	function(self, t)
		-- Debug
		-- wvprint(inspect(self))

		-- Redraw
		self:emit_signal("widget::updated")
	end)
testWidget:connect_signal("mouse::leave",
	function(self)
		-- Redraw
		self:emit_signal("widget::updated")
	end)
testWidget:connect_signal("button::press",
	function(self, x, y, button, t)
		if button == 1 then
			wvprint("Left Click")
		elseif button == 2 then
			wvprint("Middle Click")
		elseif button == 3 then
			wvprint("Right Click")
		elseif button == 8 then
			wvprint("Back Click")
		elseif button == 9 then
			wvprint("Forward Click")
		elseif button == 5 then
			wvprint("Scroll Towards Me")
		elseif button == 4 then
			wvprint("Scroll Away From Me")
		else
			wvprint(button)
		end

		-- wvprint(inspect(self))
		-- wvprint(inspect(x))
		-- wvprint(inspect(y))
		-- wvprint(inspect(button))
		-- wvprint(inspect(t))
		-- wvprint(inspect(h))



		self.pressed = true
		self:emit_signal("widget::updated")
	end)
testWidget:connect_signal("button::release",
	function(self)
		self.pressed = false
		self:emit_signal("widget::updated")
	end)



-- Testinf
-- wvprint(inspect(require('oocairo')))
-- wvprint(inspect(os.date('%I')))

-- Return Created Instance
return testWidget