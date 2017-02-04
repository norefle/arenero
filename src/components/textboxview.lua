local Export = require "core.utils.export"
local Component = require "core.component"
local Class = require "core.utils.class"

local View = {}

function View:init(args)
    self.width = args.width
    self.height = args.height
    self.margin = args.margin
    self.textHeight = args.textHeight
end

function View:draw(dt, boundingbox)
    if not self.source then
        self.source = self.entity:component("model")
    end

    local width = math.min(self.width, boundingbox.right - boundingbox.left)
    local height = math.min(self.height, boundingbox.bottom - boundingbox.top)
    local left = boundingbox.left + self.margin
    local top = boundingbox.bottom - height - self.margin

    love.graphics.setColor(0, 0, 0, 128)
    love.graphics.rectangle("fill", left, top, width, height)
    love.graphics.setColor(204, 211, 222)

    local index = 1
    --- @todo Add range creation based on tail.
    self.source:foreach(function(string)
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

return Export {
    create = function(engine, entity, width, height)
        local args = {
            width = width,
            height = height,
            margin = 5,
            textHeight = 15
        }

        return Component(engine, entity, "TextBox::View", View, args)
    end
}
