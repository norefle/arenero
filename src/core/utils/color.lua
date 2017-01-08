--[[----------------------------------------------------------------------------
----------------------------------------------------------------------------]]--

local Class = require "core.utils.class"

local Color = Class("Color")

function Color.create(r, g, b, a)
    -- black opaque by default
    local object = { r = r or 0, g = g or 0, b = b or 0, a = a or 255 }
    return setmetatable(object, { __index = Color })
end

function Color:unpack()
    return self.r, self.g, self.b, self.a
end

local _M = {
    create = function(...)
        return Color.create(...)
    end
}

local _M_mt = {
    __call = function(self, ...)
        return Color.create(...)
    end
}

return setmetatable(_M, _M_mt)
