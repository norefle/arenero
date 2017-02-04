--[[----------------------------------------------------------------------------
--- @file queue.lua
--- @brief Main structure for the all engine elements.
----------------------------------------------------------------------------]]--

local Queue = {}

local function create(data)
    local object = { data = { } }
    local result = setmetatable(object, { __index = Queue })

    if data then
        for _, value in pairs(data) do
            result:push(value)
        end
    end

    return result
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

function Queue:length()
    return #self.data
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

function Queue:find(predicate)
    for _, value in pairs(self.data) do
        if predicate(value) then
            return value
        end
    end

    return nil
end

local Range = { }

function Range.create(queue, from, to)
    local object = { data = queue, from = from, to = to }
    return setmetatable(object, { __index = Range })
end

function Range:length()
    return (self.to - self.from) + 1
end

function Range:foreach(fn)
    for i = self.from, self.to, 1 do
        fn(self.data:at(i), i - self.from + 1)
    end
end

function Queue:range(from, to)
    return Range.create(self, from, to)
end

return {

--- @param data (Optional) List/array of the data to initialize a new queue with.
create = create

}
