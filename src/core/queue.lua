--[[----------------------------------------------------------------------------
--- @file queue.lua
--- @brief Main structure for the all engine elements.
----------------------------------------------------------------------------]]--

local Queue = {}

local function create()
    local object = { data = { } }
    return setmetatable(object, { __index = Queue })
end

function Queue:push(object)
    if object then
        self.data[#self.data + 1] = object
    end
end

function Queue:at(index)
    if index < 0 or #self.data < index then
        error("Invalid argument (out of range): " .. index, 2)
    end

    return self.data[index]
end

function Queue:foreach(fn)
    for _, value in pairs(self.data) do
        fn(value)
    end
end

function Queue:map(tranform)
    local transformed = create()
    self:foreach(function(value)
        transformed:push(tranform(value))
    end)

    return transformed
end

function Queue:filter(predicate)
    local filtered = create()
    self:foreach(function(value)
        if predicate(value) then
            filtered:push(value)
        end
    end)

    return filtered
end

return { create = create }
