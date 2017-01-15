--[[----------------------------------------------------------------------------
----------------------------------------------------------------------------]]--

local Export = require "core.utils.export"

local Class = {
    __type = "class"
}

local function clone(base)
    local object = { }
    for key, value in pairs(base) do
        object[key] = value
    end

    local base_mt = getmetatable(base)
    if base_mt then
        for key, value in pairs(base_mt.__index) do
            object[key] = value
        end
    end

    return object
end

function Class:create(name, super, instance)
    local object = instance and clone(instance) or {}
    object.__type = name or "unknown"
    object.__super = super

    return setmetatable(object, self)
end

function Class:__index(key)
    local super = rawget(self, "__super")
    return ("table" == type(super))
        and super[key]
        or rawget(Class, key)
end

function Class:__tostring()
    return self.__type
end

return Export {
    create = function(...) return Class:create(...) end
}
