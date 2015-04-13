temperature = wibox.widget.textbox()
-- TODO: Move to delcarations
TEMPERATURE_UPDATE_INTERVAL = 10
TEMPERATURE_FAN_TEMP=45

temperature.reload = function(self)
	-- Run 'sensors'
	local output = execForOutput("sensors")

	-- Parse Temperature
	local temperature = string.match(split(output, ":%s*%+")[3] or "", "%d*")
	-- Display Formatte Temperature
	self:set_markup(temperature .. "° ")


	-- Modulate Temperature (Only if enabled)
	if (self.controlEnabled and tonumber(temperature) >= TEMPERATURE_FAN_TEMP) then
		awful.util.spawn_with_shell("/home/william/.local/bin/FanSpeed") -- TODO: Change to a constant, or even better, remove from here, cause it's not really applicable...
	end
end

temperature.init = function(self)
	self.controlEnabled = true
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

		if button == 1 then
			self:reload()
			
		elseif button == 3 then -- Right
			-- TODO: Show that control is disabled
			self.controlEnabled = not self.controlEnabled
		end

		-- Update
		self:emit_signal("widget::updated")
	end)

-- Return Created Instance
return temperature