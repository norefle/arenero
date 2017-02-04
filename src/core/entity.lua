--[[----------------------------------------------------------------------------
----------------------------------------------------------------------------]]--

local Class = require "core.utils.class"
local Export = require "core.utils.export"
local Queue = require "core.queue"

local Entity = Class("Entity")

function Entity:init()
    self.components = Queue.create()
end

function Entity:addComponent(componentType, component)
    assert(nil ~= componentType, "Expects valid component type")
    assert("table" == type(component), "Expects component to be valid.", 2)

    local exists = self.components:find(function(item)
        return item.name == componentType
    end)
    assert(not exists, "Component already exists: " .. componentType, 2)

    self.components:push({ component = component, name = componentType })
end

function Entity:component(componentType)
    assert(nil ~= componentType, "Expects component type to be valid.", 2)

    local result = self.components:find(function(item)
        return item.name == componentType
    end)
    assert(nil ~= result, "Can't find required component: " .. componentType, 2)

    return result.component
end

return Export {
    create = function(name, object, args)
        assert(type(name) == "string", "Can't create a nameless entity.", 2)

        return Class {
            name = name,
            extends = Entity,
            instance = object,
            args = args
        }
    end
}
