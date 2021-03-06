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

    if type(base.__super) == "table" then
        for key, value in pairs(base.__super) do
            if not object[key] then
                object[key] = value
            end
        end
    end

    local base_mt = getmetatable(base)
    if base_mt  and "table" == type(base_mt.__index) then
        for key, value in pairs(base_mt.__index) do
            if not object[key] then
                object[key] = value
            end
        end
    end

    return object
end

function Class:create(argument)
    local object
    if not argument or type(argument) == "string" then
        object = { }
        object.__type = argument or "unknown"
    elseif type(argument) == "table" then
        object = argument.instance and clone(argument.instance) or {}
        object.__type = argument.name or "unknown"
        object.__super = argument.extends
    else
        error("Can't create class parametrized with a type " .. type(argument), 2)
    end

    setmetatable(object, self)

    local super = rawget(object, "__super")
    if super and type(super.init) == "function" then
        local args = type(argument) == "table" and argument.args or nil
        super:init(args)
    end

    if type(object.init) == "function" then
        local args = type(argument) == "table" and argument.args or nil
        object:init(args)
    end

    return object
end

function Class:__index(key)
    local super = rawget(self, "__super")
    return ("table" == type(super))
        and super[key]
        or rawget(Class, key)
end

function Class:__tostring()
    return "[Class::" .. self.__type .. "]"
end

return Export {
    create = function(...) return Class:create(...) end
}
