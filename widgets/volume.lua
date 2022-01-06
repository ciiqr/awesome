local beautiful = require("beautiful")
local textbox = require("wibox.widget.textbox")
local mousebindings = require("mousebindings")
local volume = require("system.volume")

local M = {}; M.__index = M

local function construct(_, config)
    local self = textbox()
    setmetatable(self, M)

    self:init(config)

    return self
end

function M:init(config)
    -- buttons
    local buttons = mousebindings.widget(config.mousebindings)
    self:buttons(buttons)

    -- signals
    volume:connect_signal(volume.CHANGED, function() self:update() end)

    -- first update
    self:update()
end

function M:update()
    -- used to use: '🔇' or '🔈' really font dependent though
    local colour = '#ffaf5f'
    local icon = volume.isMuted() and '' or ''
    local percent = volume.getVolume()
    local markup =
        '<span foreground="' .. colour .. '" weight="bold" font="' .. beautiful.icon_font .. '">' .. icon .. '</span>' ..
        '<span foreground="' .. colour .. '" weight="bold"> ' .. percent .. '</span>'

    self:set_markup(markup)
end

return setmetatable(M, {__call = construct})
