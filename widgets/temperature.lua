temperature = wibox.widget.textbox()
TEMPERATURE_UPDATE_INTERVAL = 10
TEMPERATURE_FAN_TEMP=50

temperature.reload = function(self)
	-- Run 'sensors'
	local tempProcess = io.popen("sensors")
	-- Read All Output
	local output = tempProcess:read("*all")
	-- Close Process
	tempProcess:close()

	-- Parse Temperature
	local temperature = string.match(split(output, ":%s*%+")[3] or "", "%d*")
	-- Display Formatte Temperature
	self:set_markup(temperature .. "° ")


	-- Modulate Temperature (Only if enabled)
	if (self.controlEnabled and tonumber(temperature) >= TEMPERATURE_FAN_TEMP) then
		awful.util.spawn_with_shell("/home/william/.local/bin/FanSpeed")
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
			self.controlEnabled = not self.controlEnabled
		end

		-- Update
		self:emit_signal("widget::updated")
	end)

-- Return Created Instance
return temperature