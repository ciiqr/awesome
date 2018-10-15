--
-- Name:            divider
--
-- Author:          William A. Villeneuve
-- Date Created:    June 4, 2015
-- Date Modified:   June 4, 2015
--
-- Description:     A widget which will be added to a wibox within the Awesome Window Manager,
--                  it is intended to put visual space between other widgets.
--
-- Usage Notes:     Force a redraw with: divider:emit_signal("widget::updated")

-----------------------------------------------------------------------------------------------


-- Retrieve from globals if they exist or require if they don't
local wibox = wibox or require('wibox')
local math  = math  or require('math')

-- Move
local Orientation = {
    Vertical = "vertical",
    Horizontal = "horizontal"
}


-- Utilities
-- Widget Instance
local divider = { mt = {} }

-- Fields
divider.size = 10
divider.total_size = 10
divider.end_padding = 0
divider.orientation = Orientation.Vertical

-- Methods
divider.fit = function(self, width, height)
    local total_size = self.total_size

    if self.orientation == Orientation.Vertical then
        -- Width is total_size, height is max
        return total_size, height - self.end_padding
    else -- Horizontal
        -- Width is max, height is total_size
        return width - self.end_padding, total_size
    end
end

divider.draw = function(self, wibox, cr, width, height)
    -- cr:set_source_rgb(255, 172, 0)
    if self.orientation == Orientation.Vertical then
        local yStart = height / 4
        local yEnd = height - yStart

        -- Centre it
        local x = width / 2

        cr:move_to(x, yStart)
        cr:line_to(x, yEnd)
    else
        local xStart = 0
        local xEnd = width

        -- Centre it
        local y = height / 2

        cr:move_to(xStart, y)
        cr:line_to(xEnd, y)
    end

    cr:set_line_width(self.size)
    cr:set_line_cap("ROUND")
    cr:stroke()
end

function divider.mt:__call(args)
    local widget = wibox.widget.base.make_widget()

    -- Assign values in divider to the new widget
    for k, prop in pairs(divider) do
        widget[k] = prop
    end

    -- Override properties
    -- TODO: Don't do it this way because then we possibly set things twice...
    for k, prop in pairs(args) do
        widget[k] = prop
    end

    return widget
end

-- Return divider class
return setmetatable(divider, divider.mt)
