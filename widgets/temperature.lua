local wibox = require("wibox")
local gears = require("gears")
local systemTemperature = require("system.temperature")

temperature = wibox.widget.textbox()
temperature:set_align("center")

temperature.reload = function(self)
    local temperature = systemTemperature.get()
    self:set_markup('<span weight="bold">' .. temperature .. "°" .. '</span>')
end

temperature.init = function(self)
    self:reload()

    -- Timer for every 10 seconds
    self.updateTimer = gears.timer({timeout = CONFIG.widgets.temperature.interval})

    -- Event Handler
    self.updateTimer:connect_signal("timeout", function()
        self:reload()
    end)

    -- Start Timer
    self.updateTimer:start()

    return self
end

-- Signals
temperature:connect_signal("button::press", function(self, x, y, button, t)
    self:reload()

    -- Update
    self:emit_signal("widget::updated")
end)

-- Return Created Instance
return temperature
