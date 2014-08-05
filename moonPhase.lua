--[[
-- Name:			Moon Phase
-- 
-- Author:			William A. Villeneuve
-- Date Created:	October 13, 2013
-- Date Modified:	October 14, 2013
-- 
-- Description:		A widget which will be added to a wibox within the Awesome Window Manager,
-- 					it will retrieve the current moon phase and display it appropriatly.
--
-- Usage Notes:		Force a redraw with: moonPhase:emit_signal("widget::updated")
--
-- Api:				The api is avaiable at www.hamweather.com
--]]---------------------------------------------------------------------------------------------


-- Retrieve from globals if they exist or require if they don't
-- local gears = gears or require("gears")
-- local awful = awful or require('awful')
local wibox = wibox or require('wibox')
local http  = http  or require("socket.http")
http.TIMEOUT = 2 -- To Prevent waiting forever when loading awesome

-- Widget Instance
local moonPhase = wibox.widget.textbox("Initial")

-- Override Originals
moonPhase.original_fit = moonPhase.fit
moonPhase.fit = function(self, width, height)
	
	return self.original_fit(self, width, height)
end

moonPhase.original_draw = moonPhase.draw
moonPhase.draw = function(self, wibox, cr, width, height)
-- notify_send(inspect(wibox, 1))
	-- Background
	-- cr:save()
	-- 	cr:set_source_rgba(63/255, 63/255, 63/255, 1)
	-- 	cr:paint()
	-- cr:restore()
	return self.original_draw(self, wibox, cr, width, height)
end



-- Methods
moonPhase.reload = function(self)
	-- local requestRet = http.request("http://api.aerisapi.com/sunmoon/moonphases/toronto,on,ca?from=2012-01-01&to=2012-12-31&limit=1&client_id=HHyE3BkJUrVNR25yvkaTI&client_secret=913m5WSw72be9BU1VGHAs3bhKLW6STp8yRMERzPC") or ""
	local requestRet = http.request("http://api.aerisapi.com/sunmoon/moonphases/toronto,on,ca?client_id=HHyE3BkJUrVNR25yvkaTI&client_secret=913m5WSw72be9BU1VGHAs3bhKLW6STp8yRMERzPC") or ""

    local moonValue = string.match(split(requestRet, "code\":")[2] or "", "%d")
    local moonphases = {"🌑", "🌓", "🌕", "🌗"}
    
    local displayVal
    if moonValue == nil then
        displayVal = "nan"
    else
        displayVal = moonphases[tonumber(moonValue)+1]
    end
	self:set_markup('<span face="Quivira" weight="bold" size="xx-large" foreground="#778BAF">'.. displayVal ..'</span>  ')
end

moonPhase.init = function(self)
	-- self:align("center")
	self:reload()
	return self
end

moonPhase.cycleTimer = function(self)
	if self.timerMoonCycleState == 1 then
		self:set_markup('<span face="Quivira" weight="bold" size="xx-large" foreground="#778BAF">'.. "🌑" ..'</span>  ')
		self.timerMoonCycleState = 2
	elseif self.timerMoonCycleState == 2 then
		self:set_markup('<span face="Quivira" weight="bold" size="xx-large" foreground="#778BAF">'.. "🌓" ..'</span>  ')
		self.timerMoonCycleState = 3
	elseif self.timerMoonCycleState == 3 then
		self:set_markup('<span face="Quivira" weight="bold" size="xx-large" foreground="#778BAF">'.. "🌕" ..'</span>  ')
		self.timerMoonCycleState = 4
	elseif self.timerMoonCycleState == 4 then
		self:set_markup('<span face="Quivira" weight="bold" size="xx-large" foreground="#778BAF">'.. "🌗" ..'</span>  ')
		self.timerMoonCycleState = nil
	else
		self.timer:stop()
		self.timer = nil

		self:reload()
	end
end

moonPhase:connect_signal("button::press",
	function(self, x, y, button, t)
		if button == 1 then
			-- Setup Timer
            self.timer = timer({timeout = 0.50})
            self.timerMoonCycleState = 1
            -- Timer Callback
            self.timer:connect_signal("timeout", function() self:cycleTimer() end)
            -- Start Timer
            self.timer:start()
        elseif button == 3 then
            notify_send("Reloading Moon Phase...")
			self:reload()
            -- self:emit_signal("widget::updated")
		end
	end)

-- Return Created Instance
return moonPhase