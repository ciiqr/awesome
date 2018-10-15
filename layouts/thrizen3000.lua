
-- Grab environment we need
local pairs = pairs

local thrizen = {
    name = "thrizen",
}

-- TODO: This needs to be tweaked to position the windows appropriately, but the sizing and general layout is good
function thrizen.arrange(p)
    local area = p.workarea

    local columns = 3

    -- Area is devided into 1-3 even columns
    -- then new rows start after that...
    local numClients = #p.clients
    local width = area.width / (numClients > columns and columns or numClients)
    local numRows = math.ceil(numClients / columns)
    local height = area.height / numRows

    p_clients = {}
    for i, c in pairs(p.clients) do
        table.insert(p_clients, 1, c)
    end

    for i, c in pairs(p_clients) do
        local row = math.floor((i - 1) / columns)
        local column = ((i - 1) % columns)
        --
        local hasRoomToFill = ((i - 1 + columns) >= numClients)
        local isSecondLastRow = row == (numRows - 2)
        local isDoubleHeight = hasRoomToFill and isSecondLastRow

        local g = {
            x = area.width - (area.x + (column + 1) * width),
            y = area.y + row * height,
            width = width,
            height = isDoubleHeight and 2*height or height
        }
        p.geometries[c] = g
    end
end

return thrizen
