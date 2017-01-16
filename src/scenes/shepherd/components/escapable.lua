--[[----------------------------------------------------------------------------
----------------------------------------------------------------------------]]--

local Export = require "core.utils.export"

local Escapable = {}

function Escapable:keypress(dt, key)
    if key == "escape" then
        self.engine:queue("start", "grid")
        return true
    end

    return false
end

return Export {
    create = function()
        return setmetatable({}, { __index = Escapable })
    end
}
