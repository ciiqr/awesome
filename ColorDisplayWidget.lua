--[[
-- Name:			ColorDisplayWidget
-- 
-- Author:			William A. Villeneuve
-- Date Created:	October 6, 2013
-- Date Modified:	October 6, 2013
-- 
-- Description:		A widget which will be added to a wibox within the Awesome Window Manager,
-- 					it is intended to test colors by passing an array of color codes.
--
-- Usage Notes:		Force a redraw with: ColorDisplayWidget:emit_signal("widget::updated")

-- Ideas:			2 circles with a piece missing, each going opposite directions, one inside the other, one white, the other clightly transparent red

--]]---------------------------------------------------------------------------------------------


-- Retrieve from globals if they exist or require if they don't
local gears = gears or require("gears")
local awful = awful or require('awful')
local wibox = wibox or require('wibox')
local math  = math  or require('math')

-- Widget Instance
local ColorDisplayWidget = wibox.widget.textbox()

-- Fields
-- ColorDisplayWidget.pressed = false

-- Methods
-- ColorDisplayWidget.fit = function(self, width, height)
-- 	local size = math.min(width, height)
-- 	return size - size/3, size
-- end
ColorDisplayWidget.original_draw = ColorDisplayWidget.draw
ColorDisplayWidget.draw = function(self, wibox, cr, width, height)
	-- Background
	if self.display_background then

		cr:save()
			cr:set_source_rgba(63/255, 63/255, 63/255, 1)
			cr:paint()
		cr:restore()
	end
	return self.original_draw(self, wibox, cr, width, height)
end
-- ColorDisplayWidget.draw = function(self, wibox, cr, width, height)
-- -- Background
-- 	-- cr:save()
-- 	-- 	cr:set_source_rgba(63/255, 63/255, 63/255, 1)
-- 	-- 	cr:paint()
-- 	-- cr:restore()
-- end
ColorDisplayWidget.setup = function(self)
	-- Make sure we have colors set
	if not self.colors then return end

	-- Constants and text
	local colorMarkupText = '| '
	local COLOR_PREFIX = '<span foreground="#'
	local COLOR_POSTFIX = '" weight="bold">  ■  </span>  '
	
	-- Itterate colors and add to widget
	for colorIndex = 1, #self.colors do
		-- Get Current Color
		local color = self.colors[colorIndex]

		-- Concatinate with markup
		colorMarkupText = colorMarkupText..COLOR_PREFIX..color..COLOR_POSTFIX
	end
	-- Colors in no longer needed
	self.colors = nil

	-- Set Ending Marker
	colorMarkupText = colorMarkupText..'|  '

	-- Set Markup
	self:set_markup(colorMarkupText)
end

ColorDisplayWidget.init = function(self, colors)
	self.colors = colors
	self:setup()
	return self
end

-- Signals
ColorDisplayWidget:connect_signal("mouse::enter",
	function(self, t)
		-- Debug
		-- notify_send(inspect(self))

		-- Redraw
		self:emit_signal("widget::updated")
	end)
ColorDisplayWidget:connect_signal("mouse::leave",
	function(self)
		-- Redraw
		self:emit_signal("widget::updated")
	end)
ColorDisplayWidget:connect_signal("button::press",
	function(self, x, y, button, t)
		if button == 1 then
			notify_send("Left Click")
		elseif button == 2 then
			notify_send("Middle Click")
		elseif button == 3 then
			notify_send("Right Click")
		elseif button == 8 then
			notify_send("Back Click")
		elseif button == 9 then
			notify_send("Forward Click")
		elseif button == 5 then
			notify_send("Scroll Towards Me")
		elseif button == 4 then
			notify_send("Scroll Away From Me")
		else
			notify_send(button)
		end


		self.pressed = true
		self:emit_signal("widget::updated")
	end)
ColorDisplayWidget:connect_signal("button::release",
	function(self)
		self.pressed = false
		self:emit_signal("widget::updated")
	end)



-- Testinf
-- notify_send(inspect(require('oocairo')))
-- notify_send(inspect(os.date('%I')))

-- Return Created Instance
return ColorDisplayWidget