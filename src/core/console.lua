--[[----------------------------------------------------------------------------
----------------------------------------------------------------------------]]--

local Queue = require "core.queue"
local Class = require "core.utils.class"
local Export = require "core.utils.export"

local Console = Class("Console")

local Drawable = {}

function Drawable:draw(dt, boundingbox)
    local width = math.min(self.width, boundingbox.right - boundingbox.left)
    local height = math.min(self.height, boundingbox.bottom - boundingbox.top)
    local left = boundingbox.left + self.margin
    local top = boundingbox.bottom - height - self.margin

    love.graphics.setColor(0, 0, 0, 128)
    love.graphics.rectangle("fill", left, top, width, height)
    love.graphics.setColor(204, 211, 222)

    local index = 1
    --- @todo Add range creation based on tail.
    self.data:foreach(function(string)
        love.graphics.printf(
            string,
            left + self.margin,
            top + self.margin + (index - 1) * self.textHeight,
            width - self.margin,
            "left"
        )
        index = index + 1
    end)

    return true
end

function Console:init(args)
    self.engine = args.engine
    local drawable = {
        data = Queue.create(), -- extract model
        width = args.width,
        height = args.height,
        margin = args.margin,
        textHeight = args.textHeight
    }
    setmetatable(drawable, { __index = Drawable })

    self.render = self.engine:component("render", "Console::Drawable", false, drawable)
    self:clear()
end

function Console:clear()
    self.render.data = Queue.create()
end

function Console:add(pattern, ...)
    self.render.data:push(string.format(pattern, ...))
end

return Export {

create = function(engine, width, height)
    return Class {
        name = "Console",
        extends = Console,
        args = {
            engine = engine,
            width = width,
            height = height,
            margin = 5,
            textHeight = 15
        }
    }
end

}
