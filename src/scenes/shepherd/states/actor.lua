--[[----------------------------------------------------------------------------
- @file states/map.lua
----------------------------------------------------------------------------]]--

local Actor = {}

return {

create = function(name, position)
    local object = {
        name = name,
        position = position
    }

    return setmetatable(object, { __index = Actor })
end

}
