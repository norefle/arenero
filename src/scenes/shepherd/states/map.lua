--[[----------------------------------------------------------------------------
- @file states/map.lua
----------------------------------------------------------------------------]]--

local Map = {}

return {

create = function(width, height)
    local object = { }
    object.tiles = { }
    object.rows = height
    object.columns = width
    object.current = 1

    for i = 1, width * height, 1 do
        object.tiles[#object.tiles + 1] = (i % 4) + 1
    end

    return setmetatable(object, { __index = Map })
end

}
