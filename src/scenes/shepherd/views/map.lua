--[[----------------------------------------------------------------------------
- @file views/map.lua
----------------------------------------------------------------------------]]--

local Color = require "core.utils.color"

local Config = {

tiles = { "blank" },
size = 64,
halfSize = 32,
viewport = { columns = 10, rows = 7 },

}

local Map = { }

--- @todo Replace with proper tile assets
local function drawTile(x, y, type)
    local tiles = {
        Color(250, 250, 250, 128), -- 1
        Color(250, 64, 64, 128),   -- 2
        Color(64, 250, 64, 128),   -- 3
        Color(64, 64, 250, 128),   -- 4
    }
    love.graphics.setColor(tiles[type]:unpack())
    love.graphics.rectangle("fill", x, y, Config.size, Config.size)
end

--- @todo Replace with proper actor assets.
local function drawActor(x, y, type)
    local assets = {
        ["player"] = Color(255, 0, 0),
        ["wolf"] = Color(128, 128, 128)
    }
    love.graphics.setColor(assets[type]:unpack())
    love.graphics.circle("fill", x + Config.halfSize, y + Config.halfSize, Config.halfSize / 2)
end

function Map:draw(boundingbox)
    local screenWidth = boundingbox.right - boundingbox.left
    local screenHeight = boundingbox.bottom - boundingbox.top

    Config.viewport.columns = math.modf(screenWidth / Config.size, 1)
    Config.viewport.rows = math.modf(screenHeight / Config.size, 1)

    local viewportWidth = Config.viewport.columns * Config.size
    local viewportHeight = Config.viewport.rows * Config.size
    local screenOffset = {
        x = math.modf((screenWidth - viewportWidth) / 2, 1),
        y = math.modf((screenHeight - viewportHeight) / 2, 1)
    }

    local firstRow = math.modf(self.model.current / self.model.rows, 1) + 1
    local firstColumn = math.modf((self.model.current - 1) % self.model.rows, 1) + 1
    local rowsInViewport = math.min(self.model.rows - (firstRow - 1), Config.viewport.rows) - 1
    for i = firstRow, firstRow + rowsInViewport, 1 do
        -- width - current - 1, where -1 is because current starts from 1
        local width = math.min(self.model.columns - (firstColumn - 1), Config.viewport.columns)
        local offset = (i - 1) * self.model.columns + (firstColumn - 1)
        local row = self.model.tiles:range(offset + 1, offset + width)
        row:foreach(function(tile, index)
            local x = screenOffset.x + (index - 1) * Config.size
            local y = screenOffset.y + (i - firstRow) * Config.size
            drawTile(x, y, tile)
            -- Debug
            love.graphics.setColor(0, 0, 0, 64)
            love.graphics.printf(offset + index, x, y + 15, Config.size, "center")
        end)
    end

    self.actors:foreach(function(actor)
        local column = math.modf((actor.position - 1) % self.model.rows, 2) + 1
        local row = math.modf(actor.position / self.model.rows, 1) + 1
        if firstRow <= row
            and row <= (firstRow + Config.viewport.rows)
            and firstColumn <= column
            and column <= (firstColumn + Config.viewport.columns)
        then
            local x = screenOffset.x + ((column - firstColumn) * Config.size)
            local y = screenOffset.y +  ((row - firstRow) * Config.size)
            drawActor(x, y, actor.name)
        end
    end)
end

return {

create = function(model, actors)
    local object = {
        model = model,
        actors = actors,
        viewport = { from = 1, to = Config.viewport.columns * Config.viewport.rows },
    }

    return setmetatable(object, { __index = Map })
end

}
