--[[----------------------------------------------------------------------------
- @file states/map.lua
----------------------------------------------------------------------------]]--

local Actor = {}

function Actor:role(dt)
    if self.position > 10 then
        self.position = self.position - 1
    else
        self.position = self.position + 40
    end
end

return {

create = function(position)
    local object = { position = position }
    return setmetatable(object, { __index = Actor })
end,

}
