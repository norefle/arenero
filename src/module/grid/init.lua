--[[----------------------------------------------------------------------------
- @file init.lua
- @brief Entry point for grid module.
-
- Isometric grid drawer.
----------------------------------------------------------------------------]]--

-- Shortcut for love.graphics
local lg
local console

local background = { r = 136, g = 177, b = 247, a = 255 }
local border = { r = 204, g = 211, b = 222, a = 255 }
local semiborder = { r = 204, g = 211, b = 222, a = 128 }

local function init(graphics, output)
    lg = graphics
    console = output
end

local function draw(boundingbox)
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

    lg.setColor(border.r, border.g, border.b, border.a)

    lg.line(top.x, top.y, left.x, left.y)
    lg.line(left.x, left.y, bottom.x, bottom.y)
    lg.line(bottom.x, bottom.y, right.x, right.y)
    lg.line(right.x, right.y, top.x, top.y)

    local steps = 80
    local step = { dx = width / steps, dy = totalHeight / steps }

    for i = 1, steps, 1 do
        local from = { x = left.x + step.dx * i, y = left.y + step.dy * i }
        local to = { x = top.x + step.dx * i, y = top.y + step.dy * i }
        if 0 == i % 8 then
            lg.setColor(border.r, border.g, border.b, border.a)
        else
            lg.setColor(semiborder.r, semiborder.g, semiborder.b, semiborder.a)
        end
        lg.line(from.x, from.y, to.x, to.y)
    end
    for j = 1, steps, 1 do
        local from = { x = left.x + step.dx * j, y = left.y - step.dy * j }
        local to = { x = bottom.x + step.dx * j, y = bottom.y - step.dy * j }
        if 0 == j % 8 then
            lg.setColor(border.r, border.g, border.b, border.a)
        else
            lg.setColor(semiborder.r, semiborder.g, semiborder.b, semiborder.a)
        end
        lg.line(from.x, from.y, to.x, to.y)
    end

    console:add("Grid: size = (" .. step.dx .. ", " .. step.dy .. ")")
end

local function nothing()

end

-- Export
return {
    init = init,
    draw = draw,
    up = nothing,
    down = nothing
}
