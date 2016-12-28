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

    grid.modules = Queue.create()

    local moduleNames = love.filesystem.getDirectoryItems("module")
    for _, name in pairs(moduleNames) do
        if love.filesystem.isDirectory("module/" .. name) then
            grid.modules:push(require("module." .. name))
        end
    end

    grid.modules:foreach(function(module)
        module.init(love.graphics, Engine.console)
        if module.thumbnail then
            module.preview = love.graphics.newImage("module/template/" .. module.thumbnail)
        else
            module.preview = love.graphics.newImage("asset/thumbnail.png")
        end
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
