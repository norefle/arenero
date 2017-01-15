--[[----------------------------------------------------------------------------
- @brief Map module.
-
- Drawing tiled map in isomeric projection.
----------------------------------------------------------------------------]]--

local lg = love.graphics

local C = {}
C.TILE_WIDTH = 64
C.TILE_HEIGHT = 32

C.grid = false

local Tileset = {}
Tileset.set = nil
Tileset.tiles = {}
Tileset.width = 0
Tileset.height = 0

local Map = { }

function Map.new(x, y, level, width, height)
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
        col = level.width,
        row = 1
    }
    object.dataWidth = level.width
    object.dataHeight = level.height
    -- offset of the tiles around the grid points.

    -- Model
    object.data = level.layers[1].data

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

function Module:init()
    local err, level = pcall(require, "scenes.map.asset.level.level_1")
    Tileset.set = lg.newImage("scenes/map/asset/" .. level.tileset.image)
    Tileset.width = level.tileset.tilewidth
    Tileset.height = level.tileset.tileheight
    for i = 1, level.tileset.tilecount do
        local tile = { }
        tile.index = i
        tile.data = lg.newQuad(
            (i - 1) * Tileset.width, 0, Tileset.width, Tileset.height, Tileset.set:getDimensions()
        )
        Tileset.tiles[#Tileset.tiles + 1] = tile
    end

    -- checks
    self.map = Map.new(0, 0, level, lg.getWidth(), lg.getHeight())
end

function Module:start()
    self:subscribe("draw", false, self.name, function(...)
        self:draw(...)
    end)

    self:subscribe("keypress", true, self.name, function(dt, key)
        if key == "up" then
            return self:up(dt)
        elseif key == "down" then
            return self:down(dt)
        elseif key == "left" then
            return self:left(dt)
        elseif key == "right" then
            return self:right(dt)
        elseif key == "escape" then
            self.engine:queue("start", "grid")
            return true
        end

        return false
    end)
end

local function drawTile(name, tileType, box)
    local center = {
        x = box.x + C.TILE_WIDTH / 2,
        y = box.y + C.TILE_HEIGHT / 2
    }

    local tile = Tileset.tiles[tileType]
    if tile then
        lg.setColor(255, 255, 255, 255)
        lg.draw(Tileset.set, tile.data, box.x, box.y)
    end
    -- draw grid
    lg.setColor(0, 0, 0, 255)
    if C.grid then
        lg.line(
            box.x, center.y,
            center.x, box.y,
            box.x + C.TILE_WIDTH, center.y,
            center.x, box.y + C.TILE_HEIGHT,
            box.x, center.y
        )
        lg.printf(name, center.x - 7, center.y - 7, 20, "center")
    end
end

function Module:draw(dt, boundingbox)
    local counter = 1
    local base = { row = self.map.north.row, col = self.map.north.col }
    for row = 0, self.map.rows + 1 do
        local evenRow = (0 == row % 2)
        local cols = self.map.cols
        local left = evenRow and boundingbox.left - (C.TILE_WIDTH / 2) or boundingbox.left
        for col = cols, 1, -1 do
            local offset = cols - col
            local tail = base.col - offset
            local index = (base.row - offset - 1) * self.map.dataWidth + tail
            local tile = self.map.data[index]
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
    self.console:add(string.format("geometry %dx%d", self.map.rows, self.map.cols))
    self.console:add(string.format("mouse (%d, %d) in tile (%f, %f)", x, y, x - y, (x + y) / 2))
end

function Module:up(dt)
    self.map:moveUp()
    return true
end

function Module:down(dt)
    self.map:moveDown()
    return true
end

function Module:left(dt)
    self.map:moveLeft()
    return true
end

function Module:right(dt)
    self.map:moveRight()
    return true
end

return {

create = function()
    return setmetatable({}, { __index = Module })
end

}
