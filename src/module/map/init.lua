--[[----------------------------------------------------------------------------
- @brief Map module.
-
- Drawing tiled map in isomeric projection.
----------------------------------------------------------------------------]]--

local lg -- graphic subsystem.
local out -- debug output

local C = {}
C.TILE_WIDTH = 64
C.TILE_HEIGHT = 32

local Tile = {}
Tile.types = {
    { name = "water", color = { 0, 128, 255, 128 } },
    { name = "grass", color = { 0, 255, 128, 128 } }
}

Tile.types[0] = {
    name = "empty", color = { 0, 0, 0, 255 }
}

local Map = {}
local map = nil

function Map.new(x, y, width, height)
    local object = {}
    -- Geometry
    object.left = x
    object.rigth = x + width
    object.top = y
    object.bottom = y + height
    object.width = width
    object.height = height
    -- Multiply with 2 because we will draw tiles with the half tile step
    object.rows = math.modf(height / C.TILE_HEIGHT) * 2 + 1
    object.cols = math.modf(width / C.TILE_WIDTH) + 1

    -- State
    -- visible tiles range.
    object.north = {
        col = 25,
        row = 1
    }
    object.dataWidth = 25
    object.dataHeight = 25
    -- offset of the tiles around the grid points.

    -- Model
    object.data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
        0, 1, 2, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 2, 2, 1, 2, 1, 0,
        0, 1, 2, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 2, 2, 1, 2, 1, 0,
        0, 1, 2, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 2, 2, 1, 2, 1, 0,
        0, 1, 2, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 2, 2, 1, 2, 1, 0,
        0, 1, 2, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 2, 2, 1, 2, 1, 0,
        0, 1, 2, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 2, 2, 1, 2, 1, 0,
        0, 1, 2, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 2, 2, 1, 2, 1, 0,
        0, 1, 2, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 2, 2, 1, 2, 1, 0,
        0, 1, 2, 2, 2, 1, 2, 2, 2, 1, 2, 0, 0, 0, 1, 2, 2, 2, 1, 2, 2, 1, 2, 1, 0,
        0, 1, 2, 2, 2, 1, 2, 2, 2, 1, 2, 0, 0, 0, 1, 2, 2, 2, 1, 2, 2, 1, 2, 1, 0,
        0, 1, 2, 2, 2, 1, 2, 2, 2, 1, 2, 0, 0, 0, 1, 2, 2, 2, 1, 2, 2, 1, 2, 1, 0,
        0, 1, 2, 2, 2, 1, 2, 2, 2, 1, 2, 0, 0, 0, 1, 2, 2, 2, 1, 2, 2, 1, 2, 1, 0,
        0, 1, 2, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 2, 2, 1, 2, 1, 0,
        0, 1, 2, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 2, 2, 1, 2, 1, 0,
        0, 1, 2, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 2, 2, 1, 2, 1, 0,
        0, 1, 2, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 2, 2, 1, 2, 1, 0,
        0, 1, 2, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 2, 2, 1, 2, 1, 0,
        0, 1, 2, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 2, 2, 1, 2, 1, 0,
        0, 1, 2, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 2, 2, 1, 2, 1, 0,
        0, 1, 2, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 2, 2, 1, 2, 1, 0,
        0, 1, 2, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 2, 2, 1, 2, 1, 0,
        0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
    }

    return setmetatable(object, { __index = Map })
end

local function clap(value, min, max)
    if value < min then
        value = min
    elseif max < value then
        value = max
    end
    return value
end

local function move(map, dx, dy)
    map.north.col = clap(map.north.col + dx, 1, map.dataWidth)
    map.north.row = clap(map.north.row + dy, 1, map.dataHeight)
end

function Map:moveUp()
    move(self, 1, -1)
end

function Map:moveDown()
    move(self, -1, 1)
end

function Map:moveLeft()
    move(self, -1, -1)
end

function Map:moveRight()
    move(self, 1, 1)
end

local Module = {}

function Module.init(graphics, console)
    lg = graphics
    out = console
end

function Module.load()
    map = Map.new(0, 0, lg.getWidth(), lg.getHeight())
end

local function drawTile(name, tileType, box)
    local center = {
        x = box.x + C.TILE_WIDTH / 2,
        y = box.y + C.TILE_HEIGHT / 2
    }

    if Tile.types[tileType] then
        lg.setColor(unpack(Tile.types[tileType].color))
    else
        lg.setColor(255, 0, 0, 128)
    end

    lg.polygon(
        "fill",
        box.x, center.y,
        center.x, box.y,
        box.x + C.TILE_WIDTH, center.y,
        center.x, box.y + C.TILE_HEIGHT
    )
    lg.setColor(204, 211, 222, 255)
    -- draw grid
    lg.line(
        box.x, center.y,
        center.x, box.y,
        box.x + C.TILE_WIDTH, center.y,
        center.x, box.y + C.TILE_HEIGHT,
        box.x, center.y
    )
    lg.printf(name, center.x - 7, center.y - 7, 20, "center")
end

function Module.draw(boundingbox)
    local counter = 1
    local base = { row = map.north.row, col = map.north.col }
    for row = 0, map.rows do
        local evenRow = (0 == row % 2)
        local cols = map.cols
        local left = evenRow and boundingbox.left - (C.TILE_WIDTH / 2) or boundingbox.left
        for col = cols, 1, -1 do
            local offset = cols - col
            local tail = base.col - offset
            local index = (base.row - offset - 1) * map.dataWidth + tail
            local tile = map.data[index]
            if tile and 0 < tail then
                drawTile(
                    tostring(index),
                    tile,
                    { x = left + C.TILE_WIDTH * (col - 1), y = boundingbox.top + (C.TILE_HEIGHT / 2) * (row - 1) }
                )
            end
            counter = counter + 1
        end

        if evenRow then
            base.row = base.row + 1
        else
            base.col = base.col - 1
        end
    end

    local x = math.modf(love.mouse.getX() / C.TILE_WIDTH) + 1
    local y = math.modf(love.mouse.getY() / (C.TILE_HEIGHT / 2)) + 1
    out:add(string.format("geometry %dx%d", map.rows, map.cols))
    out:add(string.format("mouse (%d, %d) in tile (%f, %f)", x, y, x - y, (x + y) / 2))
end

function Module.unload()
    map = nil
end

function Module.up()
    map:moveUp()
end

function Module.down()
    map:moveDown()
end

function Module.left()
    map:moveLeft()
end

function Module.right()
    map:moveRight()
end

--[[------------------------------------------------------------------------]]--
return {

name = "Map",
description = "Isometric tiled map",
version = "0.1.0",
init = Module.init,
load = Module.load,
unload = Module.unload,
draw = Module.draw,
up = Module.up,
down = Module.down,
left = Module.left,
right = Module.right,

}
