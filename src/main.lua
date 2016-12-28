local Engine = require("core").create()
local Queue = require "core.queue"

local boundingbox = {
        left = 0, right = love.graphics.getWidth(),
        top = 0, bottom = love.graphics.getHeight()
}

local margin = 5
local consoleBox = {
        left = margin,
        right = boundingbox.right / 2,
        top = (boundingbox.bottom - margin) - boundingbox.bottom / 6,
        bottom = boundingbox.bottom - margin
}

function love.load()
    love.keyboard.setKeyRepeat(true)

    local grid = Engine:scene("grid")

    Engine:subscribe("keypress", "main", function(key)
        if key == "escape" then
            love.event.quit()
            return true
        end
    end)
    Engine:subscribe("draw", false, "console", function()
        Engine.console:draw(consoleBox)
    end)

    Engine:start("grid")
end

function love.resize(width, height)
    boundingbox.right = width
    boundingbox.bottom = height
end

function love.mousepressed(x, y, button)
    Engine:queue("click", x, y, button)
end

function love.keypressed(key, isrepeat)
    Engine:queue("keypress", key, isrepeat)
end

function love.update(dt)
    Engine:pump(dt)
end

function love.draw()
    love.graphics.setBackgroundColor(136, 177, 247)
    -- High priority event, call directly
    Engine:emit("draw")
end
