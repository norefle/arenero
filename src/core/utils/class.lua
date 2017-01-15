--[[----------------------------------------------------------------------------
----------------------------------------------------------------------------]]--

local Export = require "core.utils.export"

local Class = {
    __type = "class"
}

function Class:create(name, super)
    local object = {
        __type = name or "unknown",
        __super = super
    }

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
