--[[----------------------------------------------------------------------------
----------------------------------------------------------------------------]]--

local Class = require "core.utils.class"
local Export = require "core.utils.export"

local Component = Class("Component")

function Component:init(args)
    self.engine = args.engine
    self.entity = args.entity
end

return Export {
    create = function(engine, entity, name, prototype, args)
        args = args or {}
        args.engine = args.engine or engine
        args.entity = args.entity or entity

        return Class {
            name = name,
            extends = Component,
            instance = prototype,
            args = args
        }
    end
}
