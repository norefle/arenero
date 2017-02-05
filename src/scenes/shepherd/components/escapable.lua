--[[----------------------------------------------------------------------------
----------------------------------------------------------------------------]]--

local Export = require "core.utils.export"
local Component = require "core.component"
local Class = require "core.utils.class"

local Escapable = Class("Escapable::Component")

function Escapable:keypress(dt, key)
    if key == "escape" then
        self.engine:queue("start", "grid")
        return true
    end

    return false
end

return Export {
    create = function(engine, entity)
        return Component(engine, entity, "Escapable", Escapable)
    end
}
