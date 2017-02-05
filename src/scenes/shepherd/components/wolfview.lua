local Class = require "core.utils.class"
local Export = require "core.utils.export"
local Component = require "core.component"
local Color = require "core.utils.color"

local fillWith = Color(128, 128, 128)

local View = Class("Wolf::View")

function View:prepare()
    self.actor = self.actor or self.entity:component("actor")
end

function View:draw(dt, boundingbox)
    local x, y = self.actor:getX(), self.actor:getY()

    love.graphics.setColor(fillWith:unpack())
    love.graphics.circle("fill", x + 32, y + 32, 32 / 2)
end

return Export {
    create = function(engine, entity)
        return Component(engine, entity, "Wolf::View", View)
    end
}
