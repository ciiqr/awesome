local awful = require("awful")
local gears = require("gears")
local quake = require("quake")

local popup = {}

function popup.init(screen)
    for _,popup in ipairs(CONFIG.popups) do
        -- Ensure we have a table
        if not screen.quake then
            screen.quake = {}
        end

        -- get options
        local defaults = {
            screen = screen,
            border = 0,
        }
        local options = popup.options or {}
        local quakeOptions = gears.table.join(defaults, options)

        -- Create Popup
        screen.quake[popup.name] = quake(quakeOptions)
    end
end

function popup.toggle(name)
    local screen = awful.screen.focused()
    screen.quake[name]:toggle()
end

return popup
