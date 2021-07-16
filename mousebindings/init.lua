local volume = require("system.volume")
local popup = require("actions.popup")
local command = require("actions.command")

local mousebindings = {}

-- TODO: figure out a way to wrap all actions in the environment, maybe createMouseBindings simple needs a param to tell it to not pass the first bit of context... or something to wrap ie. StaticBindings(require("volume"))
function mousebindings.widget(bindings)
    local gears = require("gears")
    local binding = require("utils.binding")

    -- Buttons
    local environment = {
        awful = require("awful"),
        client = require("actions.client"),
        layout = require("actions.layout"),
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
