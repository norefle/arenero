local Utils = { }

function Utils.clap(value, min, max)
    if max < min then
        min, max = max, min
    end

    if value < min then
        value = min
    elseif max < value then
        value = max
    end
    return value
end

local Color = {}

function Utils.color(r, g, b, a)
    -- black opaque by default
    local object = { r = r or 0, g = g or 0, b = b or 0, a = a or 255 }
    return setmetatable(object, { __index = Color })
end

function Color:unpack()
    return self.r, self.g, self.b, self.a
end

return Utils
