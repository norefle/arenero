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

function Utils.clone(base)
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

return Utils
