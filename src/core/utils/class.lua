--[[----------------------------------------------------------------------------
----------------------------------------------------------------------------]]--

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
    return ("table" == type(self.__super))
        and self.__super[key]
        or Class[key]
end

function Class:__tostring()
    return self.__type
end

local _M = {
    create = function(...)
        return Class:create(...)
    end
}

local _M_mt = {
    __call = function(self, ...)
        return Class:create(...)
    end
}

return setmetatable(_M, _M_mt)
