--[[----------------------------------------------------------------------------
----------------------------------------------------------------------------]]--

local Export = require "core.utils.export"
local Component = require "core.component"

local Escapable = {}

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
