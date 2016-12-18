local Engine = require("core").create()
local Queue = require "core.queue"

local boundingbox = {
        left = 0, right = love.graphics.getWidth(),
        top = 0, bottom = love.graphics.getHeight()
}

local Console = {}

function Console:clear()
    self.data = {}
end

function Console:add(string)
    self.data = self.data or {}
    self.data[#self.data + 1] = string
end


function Console:draw(boundingbox)
    local margin = 5
    local height = 15
    local size = {
        width = boundingbox.right - boundingbox.left,
        height = boundingbox.bottom - boundingbox.top
    }

    love.graphics.setColor(0, 0, 0, 128)
    love.graphics.rectangle("fill", boundingbox.left, boundingbox.top, size.width, size.height)
    love.graphics.setColor(204, 211, 222)

    self.data = self.data or {}
    for index, text in pairs(self.data) do
        love.graphics.printf(
            text,
            boundingbox.left + margin,
            boundingbox.top + margin + (index - 1) * height,
            size.width - margin,
            "left"
        )
    end
end

local function wrap(module, console)
    local wrapper = {}

    function wrapper:add(string)
        console:add("[" .. module .. "]: " .. string)
    end

    return setmetatable(wrapper, { __index = console } )
end

function love.load()
    love.keyboard.setKeyRepeat(true)

    local grid = Engine:scene("grid")

    Engine:subscribe("keypress", "main", function(key)
        if key == "escape" then
            love.event.quit()
            return true
        end
    end)

    grid.data = require "scenes.grid"
    grid.data.init(grid, love.graphics, wrap("grid", Console))
    grid.modules = Queue.create()

    grid:subscribe("draw", "grid", function()
        grid.data.draw(grid.modules)
        return true
    end)
    grid:subscribe("click", "grid", grid.data.click)

    local moduleNames = love.filesystem.getDirectoryItems("module")
    for _, name in pairs(moduleNames) do
        if love.filesystem.isDirectory("module/" .. name) then
            grid.modules:push(require("module." .. name))
        end
    end

    grid.modules:foreach(function(module)
        module.init(love.graphics, wrap(module.name, Console))
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

    local margin = 5
    local consoleBox = {
        left = margin,
        right = boundingbox.right / 2,
        top = (boundingbox.bottom - margin) - boundingbox.bottom / 6,
        bottom = boundingbox.bottom - margin
    }

    Console:draw(consoleBox)
    --Console:clear()
end
