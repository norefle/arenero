local Model = require "components.textboxmodel"
local View = require "components.textboxview"
local Enity = require "core.entity"
local Export = require "core.utils.export"

local Console = {}

function Console:prepare()
    self.model = self.model or self:component("model")
end

function Console:add(pattern, ...)
    self:prepare()

    self.model:add(pattern, ...)
end

function Console:clear()
    self:prepare()

    self.model:clear()
end

return Export {
    create = function(engine, width, heigh)
        local entity = Enity("Console", Console)
        entity:addComponent("model", Model(engine, entity))
        entity:addComponent("view", View(engine, entity, width, heigh))

        engine:component("render", entity:component("view"))

        return entity
    end
}
