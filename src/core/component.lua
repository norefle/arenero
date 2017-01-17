--[[----------------------------------------------------------------------------
----------------------------------------------------------------------------]]--

local Class = require "core.utils.class"
local Export = require "core.utils.export"

local Component = Class("Component")

function Component:init(args)
    self.engine = args.engine
end

return Export {
    create = function(engine, name, object)
        return Class {
            name = name,
            extends = Component,
            instance = object,
            args = {
                engine = engine
            }
        }
    end
}
