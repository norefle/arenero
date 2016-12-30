--[[----------------------------------------------------------------------------
- @file views/map.lua
----------------------------------------------------------------------------]]--

local Utils = require "core.utils"

local Config = {

tiles = { "blank" },
size = 64,
viewport = { columns = 10, rows = 7 },

}

local Map = { }

--- @todo Replace with proper tile assets
local function drawTile(x, y, type)
    local tiles = {
        Utils.color(250, 250, 250, 128), -- 1
        Utils.color(250, 64, 64, 128),   -- 2
        Utils.color(64, 250, 64, 128),   -- 3
        Utils.color(64, 64, 250, 128),   -- 4
    }
    love.graphics.setColor(tiles[type]:unpack())
    love.graphics.rectangle("fill", x, y, Config.size, Config.size)
end

function Map:draw(boundingbox)
    local screenWidth = boundingbox.right - boundingbox.left
    local screenHeight = boundingbox.bottom - boundingbox.top
    local viewportWidth = Config.viewport.columns * Config.size
    local viewportHeight = Config.viewport.rows * Config.size
    local screenOffset = {
        x = math.modf((screenWidth - viewportWidth) / 2, 1),
        y = math.modf((screenHeight - viewportHeight) / 2, 1)
    }

    local firstRow = math.modf(self.model.current / self.model.rows, 1) + 1
    local firstColumn = math.modf((self.model.current - 1) % self.model.rows, 1) + 1
    local rowsInViewport = math.min(self.model.rows - firstRow, Config.viewport.rows)
    for i = firstRow, firstRow + rowsInViewport, 1 do
        -- width - current - 1, where -1 is because current starts from 1
        local width = math.min(self.model.columns - firstColumn, Config.viewport.columns)
        local offset = (i - 1) * self.model.columns + (firstColumn - 1)
        local row = self.model.tiles:range(offset + 1, offset + 1 + width)
        row:foreach(function(tile, index)
            local x = screenOffset.x + (index - 1) * Config.size
            local y = screenOffset.y + (i - firstRow) * Config.size
            drawTile(x, y, tile)
            -- Debug
            love.graphics.setColor(0, 0, 0, 64)
            love.graphics.printf(offset + index, x, y + 15, Config.size, "center")
        end)
    end
end

return {

create = function(model)
    local object = { }
    object.model = model
    object.viewport = { from = 1, to = Config.viewport.columns * Config.viewport.rows }

    return setmetatable(object, { __index = Map })
end

}
