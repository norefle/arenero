--[[----------------------------------------------------------------------------
- @file init.lua
- @brief Entry point for grid module.
-
- Isometric grid drawer.
----------------------------------------------------------------------------]]--

local Scene
-- Shortcut for love.graphics
local lg

local console

local background = { r = 136, g = 177, b = 247, a = 255 }
local border = { r = 204, g = 211, b = 222, a = 255 }
local semiborder = { r = 204, g = 211, b = 222, a = 128 }
local boundingbox = {
        left = 0, right = love.graphics.getWidth(),
        top = 0, bottom = love.graphics.getHeight()
}
local margin = 5
local text = 15
local start = { x = 100, y = 100 }
local thumbnailSize = { width = 128, height = 128 + margin + text }

local Grid = { name = "grid" }

local function clone(base)
    local object = { }
    for key, value in pairs(base) do
        object[key] = value
    end

    return object
end


function create(scene, graphics, output)
    local object = clone(Grid)
    object.lg = graphics
    object.console = output

    return setmetatable(object, { __index = scene })
end

function Grid:init()
    self:subscribe("keypress", true, self.name, function(key)
        if key == "up" then
            thumbnailSize.width = thumbnailSize.width + 10
            return true
        elseif key == "down" then
            thumbnailSize.width = thumbnailSize.width - 10
            return true
        end

        return false
    end)

    self:subscribe("click", true, self.name, function(...)
        return self:click(...)
    end)

    self:subscribe("draw", false, self.name, function(...)
        return self:draw(...)
    end)
end

function Grid:draw()
    local size = {
        width = boundingbox.right - boundingbox.left,
        height = boundingbox.bottom - boundingbox.top
    }

    local center = { x = size.width / 2, y = size.height / 2 }
    local angle = math.rad(30)
    local height = (size.width / 2) * math.tan(angle)
    local top = { x = center.x, y = -height }


    local totalHeight = height + (size.height / 2)
    local angleTop = math.rad(60)
    local width = totalHeight * math.tan(angleTop)
    local left = { x = center.x - width, y = center.y }

    local bottom = { x = top.x, y = top.y + 2 * totalHeight }
    local right = { x = center.x + width, y = center.y }

    self.lg.setColor(border.r, border.g, border.b, border.a)

    self.lg.line(top.x, top.y, left.x, left.y)
    self.lg.line(left.x, left.y, bottom.x, bottom.y)
    self.lg.line(bottom.x, bottom.y, right.x, right.y)
    self.lg.line(right.x, right.y, top.x, top.y)

    local steps = 80
    local step = { dx = width / steps, dy = totalHeight / steps }

    for i = 1, steps, 1 do
        local from = { x = left.x + step.dx * i, y = left.y + step.dy * i }
        local to = { x = top.x + step.dx * i, y = top.y + step.dy * i }
        if 0 == i % 8 then
            self.lg.setColor(border.r, border.g, border.b, border.a)
        else
            self.lg.setColor(semiborder.r, semiborder.g, semiborder.b, semiborder.a)
        end
        self.lg.line(from.x, from.y, to.x, to.y)
    end
    for j = 1, steps, 1 do
        local from = { x = left.x + step.dx * j, y = left.y - step.dy * j }
        local to = { x = bottom.x + step.dx * j, y = bottom.y - step.dy * j }
        if 0 == j % 8 then
            self.lg.setColor(border.r, border.g, border.b, border.a)
        else
            self.lg.setColor(semiborder.r, semiborder.g, semiborder.b, semiborder.a)
        end
        self.lg.line(from.x, from.y, to.x, to.y)
    end


    local index = 1
    self.modules:foreach(function(module)
        local x = start.x + (index - 1) * (thumbnailSize.width + margin)
        self.lg.setColor(0, 0, 0, 128)
        self.lg.rectangle(
            "fill",
            x,
            start.y,
            thumbnailSize.width,
            thumbnailSize.height
        )
        self.lg.setColor(204, 211, 222)
        self.lg.printf(
            module.name,
            x + margin,
            start.y + thumbnailSize.height - text,
            thumbnailSize.width - margin,
            "center"
        )
        self.lg.draw(module.preview, x, start.y)
        index = index + 1
    end)

    return true
end

function Grid:click(x, y)
    if x >= start.x and x <= (start.x + (thumbnailSize.width + margin) * 3)
        and y >= start.y and y <= (start.y + thumbnailSize.height)
    then
        -- selected template item.
        local index = (math.modf((x - start.x) / (thumbnailSize.width + margin)) + 1)
        --if index < 1 or #modules < index then
        --    error("Invalid index: " .. index)
        --end
        self.console:add("Selected module: " .. index)

        return true
    end

    return false
end

-- Export
return { create = create }
