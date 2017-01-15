--[[----------------------------------------------------------------------------
- @file init.lua
- @brief Entry point for grid module.
-
- Isometric grid drawer.
----------------------------------------------------------------------------]]--

local Queue = require "core.queue"

local background = { r = 136, g = 177, b = 247, a = 255 }
local border = { r = 204, g = 211, b = 222, a = 255 }
local semiborder = { r = 204, g = 211, b = 222, a = 128 }
local margin = 5
local text = 15
local start = { x = 100, y = 100 }
local thumbnailSize = { width = 128, height = 128 + margin + text }

local Grid = { name = "grid" }

function create()
    local object = {
        modules = Queue.create()
    }

    return setmetatable(object, { __index = Grid })
end

function Grid:init()
    local moduleNames = love.filesystem.getDirectoryItems("scenes")
    for _, name in pairs(moduleNames) do
        if name ~= self.name then
            if love.filesystem.isDirectory("scenes/" .. name) then
                local sceneModule = { name = name }
                local thumbnail = "scenes/" .. name .. "/asset/thumbnail.png"
                if not love.filesystem.isFile(thumbnail) then
                    thumbnail = "asset/thumbnail.png"
                end
                sceneModule.preview = love.graphics.newImage(thumbnail)
                self.modules:push(sceneModule)
            end
        end
    end
end

function Grid:start()
    self:subscribe("click", true, self.name, function(...)
        return self:click(...)
    end)

    self:subscribe("draw", false, self.name, function(...)
        return self:draw(...)
    end)
end

function Grid:draw(dt, boundingbox)
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

function Grid:click(dt, x, y)
    if x >= start.x and x <= (start.x + (thumbnailSize.width + margin) * self.modules:length())
        and y >= start.y and y <= (start.y + thumbnailSize.height)
    then
        -- selected template item.
        local index = (math.modf((x - start.x) / (thumbnailSize.width + margin)) + 1)
        local selected = self.modules:at(index)
        self.console:add("Selected module: " .. index .. " is " .. selected.name)

        self.engine:queue("start", selected.name)

        return true
    end

    self.console:add("Missclicked: (" .. x .. ", " .. y .. ")")

    return false
end

-- Export
return { create = create }
