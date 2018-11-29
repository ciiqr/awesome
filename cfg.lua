local lyaml = require('lyaml')
local gears = require('gears')

local path = gears.filesystem.get_configuration_dir() .. 'config.yml'
local file = assert(io.open(path, 'r'))
local content = file:read("*all")

file:close()

return lyaml.load(content)
