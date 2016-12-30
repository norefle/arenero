--[[----------------------------------------------------------------------------
----------------------------------------------------------------------------]]--

local Queue = require "core.queue"

local Console = {}

function Console:clear()
    self.data = Queue.create()
end

function Console:add(string)
    self.data:push(string)
end

--- @todo Extract to ConsoleView, keep model separately.
function Console:draw(dt, boundingbox)
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

return {

create = function(width, height)
    local object = {
        width = width,
        height = height,
        margin = 5,
        textHeight = 15
    }
    object.data = Queue.create()

    return setmetatable(object, { __index = Console })
end

}
