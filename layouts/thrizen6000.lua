
-- Grab environment we need
local pairs = pairs

local thrizen = {
    name = "thrizen",
}

function thrizen.arrange(currentScreen)
    local area = currentScreen.workarea
    local screenOffsetX = area.x
    local screenOffsetY = area.y

    local desiredColumns = 3

    -- Area is divided into 1-3 even columns
    -- then new rows start after that...

    -- Get the number of clients
    local numClients = #currentScreen.clients

    -- Determine the number of columns (min of numClients and desired columns)
    local numColumns = numClients > desiredColumns and desiredColumns or numClients
    -- Determine the individual client width based on the number of columns
    local targetWidth = area.width / numColumns

    -- Determine the number of rows (must be a whole number)
    local numRows = math.ceil(numClients / numColumns)
    -- Determine the individual client height based on the number of rows
    local targetHeight = area.height / numRows

    -- Iterate over the clients
    for i, c in pairs(currentScreen.clients) do
        -- Use the current index to determine the current column and row
        local currentColumn = ((i - 1) % numColumns)
        local currentRow = math.floor((i - 1) / numColumns)

        local isSecondLastRow = currentRow == (numRows - 2)
        local hasRoomToFill = ((i - 1 + numColumns) >= numClients)
        local isDoubleHeight = hasRoomToFill and isSecondLastRow

        local clientOffsetX = currentColumn * targetWidth
        local clientOffsetY = currentRow * targetHeight

        currentScreen.geometries[c] = {
            x = screenOffsetX + clientOffsetX,
            y = screenOffsetY + clientOffsetY,
            width = targetWidth,
            height = isDoubleHeight and 2 * targetHeight or targetHeight
        }
    end
end

return thrizen
