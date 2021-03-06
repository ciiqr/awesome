local volume = require("system.volume")
local popup = require("actions.popup")
local command = require("actions.command")

local mousebindings = {}

function mousebindings.widget(bindings)
    local gears = require("gears")
    local binding = require("utils.binding")

    -- Buttons
    local environment = {
        awful = require("awful"),
        client = require("actions.client"),
        layout = require("actions.layout"),
        -- TODO: figure out a better way of handling actions that don't want the objects they're being called on but do want normal args...
        -- TODO: maybe the best we can do for now is to add either an additional argument, or some naming convention to fix this (ie. @volume = ...); or have an object that wraps things and makes them work properly, ie. volume = StaticBindings(require("volume"))
        volume = {
            change = function(_, ...) volume.change(...) end,
        },
        popup = {
            toggle = function(_, ...) popup.toggle(...) end,
        },
        command = {
            run = function(_, ...) command.run(...) end,
        },
    }

    -- Client Mouse Bindings
    local buttons = binding.createMouseBindings(bindings, environment)
    return gears.table.join(table.unpack(buttons))

end

return mousebindings
