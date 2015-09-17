local Grid = require "module.grid"

local Modules = { require "module.picker", require "module.template" }
local Current = nill

local Thumbnail
local start = { x = 100, y = 100 }
local margin = 5
local text = 15
local size = { width = 128, height = 128 + margin + text }
local count = #Modules

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

local boundingbox = {
        left = 0, right = love.graphics.getWidth(),
        top = 0, bottom = love.graphics.getHeight()
}

function love.load()
    love.keyboard.setKeyRepeat(true)
    Thumbnail = love.graphics.newImage("asset/thumbnail.png")
    Grid.init(love.graphics, wrap("grid", Console))

    for _, module in pairs(Modules) do
        module.init(love.graphics, wrap(module.name, Console))
        if module.thumbnail then
            module.preview = love.graphics.newImage("module/template/" .. module.thumbnail)
        end
    end
end

function love.resize(width, height)
    boundingbox.right = width
    boundingbox.bottom = height
end

function love.mousepressed(x, y, button)
    if nil ~= Current then
        return
    end

    if x >= start.x and x <= (start.x + (size.width + margin) * count)
        and y >= start.y and y <= (start.y + size.height)
    then
        -- selected template item.
        local index = (math.modf((x - start.x) / (size.width + margin)) + 1)
        if index < 1 or count < index then
            error("Invalid index: " .. index)
        end
        Current = Modules[index]
        Current.load()
    end
end

function love.keypressed(key, isrepeat)
    if "escape" == key and Current then
        Current.unload()
        Current = nil
    elseif "up" == key then
        if Current and Current.up then
            Current.up()
        end
    elseif "down" == key then
        if Current and Current.down then
            Current.down()
        end
    end
end

function love.draw()
    love.graphics.setBackgroundColor(136, 177, 247)

    Grid.draw(boundingbox)

    if not Current then
        for index, module in pairs(Modules) do
            local x = start.x + (index - 1) * (size.width + margin)
            love.graphics.setColor(0, 0, 0, 128)
            love.graphics.rectangle(
                "fill",
                x,
                start.y,
                size.width,
                size.height
            )
            love.graphics.setColor(204, 211, 222)
            love.graphics.printf(
                module.name,
                x + margin,
                start.y + size.height - text,
                size.width - margin,
                "center"
            )
            love.graphics.draw(module.preview or Thumbnail, x, start.y)
        end
    else
        Current.draw(boundingbox)
    end

    local margin = 5
    local consoleBox = {
        left = margin,
        right = boundingbox.right / 2,
        top = (boundingbox.bottom - margin) - boundingbox.bottom / 6,
        bottom = boundingbox.bottom - margin
    }

    Console:draw(consoleBox)
    Console:clear()
end
