temperature = wibox.widget.textbox()

temperature.reload = function(self)
	-- Run 'sensors'
	local output = execForOutput("sensors")

	-- Parse Temperature
	local temperature = string.match(split(output, ":%s*%+")[3] or "", "%d*")
	-- Display Formatte Temperature
	self:set_markup(temperature .. "° ")
end

temperature.init = function(self)
	self:reload()

	-- Timer for every 10 seconds
	self.updateTimer = timer({timeout = TEMPERATURE_UPDATE_INTERVAL})

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

		-- if button == 1 then
			self:reload()
		-- end

		-- Update
		self:emit_signal("widget::updated")
	end)

-- Return Created Instance
return temperature
