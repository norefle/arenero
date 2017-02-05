local Entity = require "core.entity"
local Component = require "core.component"
local Export = require "core.utils.export"
local Model = require "scenes.shepherd.components.actor"
local View = require "scenes.shepherd.components.wolfview"

local Wolf = Class("Wolf")

function Wolf:init(args)
end

return Export {
    create = function(engine, position, limits, threshold)
        local entity = Entity("Wolf", Wolf)
        local model = Model(engine, entity, "Wolf::Model", position, limits, threshold)
        local view = View(engine, entity, "Wolf::View")

        entity:addComponent()
    end
}

