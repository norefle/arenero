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

    local index = 1
    self.data:foreach(function(string)
        love.graphics.printf(
            string,
            boundingbox.left + margin,
            boundingbox.top + margin + (index - 1) * height,
            size.width - margin,
            "left"
        )
        index = index + 1
    end)

    return true
end


local function create()
    local object = { }
    object.data = Queue.create()

    return setmetatable(object, { __index = Console })
end

return {
    create = create
}
