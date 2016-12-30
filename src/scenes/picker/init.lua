--[[----------------------------------------------------------------------------
- @file init.lua
- @brief Entry point for picker module.
-
- Main purpose of the module is to provide functionality for
- tile size picking.
----------------------------------------------------------------------------]]--


local background = { r = 0, g = 0, b = 0, a = 200 }
local border = { r = 204, g = 211, b = 222, a = 255 }
local tileWidth = 64
local margin = 5

local Module = {}

--- Calculates tile geometry based on its width.
-- @return tile = { width, height }
local function calculate(width)
    local halfWidth = width / 2
    local angle = math.rad(30)
    local halfHeight = halfWidth * math.tan(angle)

    return { width = width, height = halfHeight * 2 }
end

-- Generates array of coordinates for connecting them into closed tile border.
local function getBorderCoordinate(x, y, width, height)
    local rect = {
        left = x, right = x + width,
        top = y, bottom = y + height
    }

    local center = {
        x = rect.left + width / 2,
        y = rect.top + height / 2
    }

    -- Use {} here and table.unpack as soon as Lua 5.2 is here.
    return rect.left, center.y,
        center.x, rect.top,
        rect.right, center.y,
        center.x, rect.bottom,
        rect.left, center.y
end

function Module:init()
    self:subscribe("draw", false, self.name, function(...)
        self:draw(...)
    end)
    self:subscribe("keypress", true, self.name, function(dt, key)
        if key == "up" then
            return self:up(dt)
        elseif key == "down" then
            return self:down(dt)
        elseif key == "escape" then
            self.engine:queue("start", "grid")
            return true
        end

        return false
    end)
end

function Module:draw(dt, boundingbox)
    local tile = calculate(tileWidth)
    local boxSize = {
        width = boundingbox.right - boundingbox.left,
        height = boundingbox.bottom - boundingbox.top
    }

    local boxCenter = {
        x = boundingbox.left + boxSize.width / 2,
        y = boundingbox.top + boxSize.height / 2
    }

    local rect = {
        x = boxCenter.x - tile.width + margin,
        y = boxCenter.y - tile.height + margin,
        width = tile.width * 2 + 3 * margin,
        height = tile.height + 2 * margin
    }

    self.lg.setColor(background.r, background.g, background.b, background.a)
    self.lg.rectangle("fill", rect.x - margin, rect.y - margin, rect.width, rect.height)

    self.lg.setColor(border.r, border.g, border.b, border.a)
    self.lg.line(getBorderCoordinate(rect.x, rect.y, tile.width, tile.height))
    self.lg.line(getBorderCoordinate(
        rect.x + tile.width + margin,
        rect.y + (tile.height - tile.width / 2) / 2, -- centering in the background rect
        tile.width,
        tile.width / 2 -- 2:1 tile height is width / 2
    ))

    self.console:add(string.format("iso = (%f, %f)", tile.width, tile.height))
    self.console:add(string.format("2:1 = (%f, %f)", tile.width, tile.width / 2))
end

function Module:up(dt)
    tileWidth = tileWidth + 2
    return true
end

function Module:down(dt)
    tileWidth = tileWidth - 2
    return true
end


-- Export
return {

create = function()
    return setmetatable({}, { __index = Module })
end

}
