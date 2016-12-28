--[[----------------------------------------------------------------------------
--- @file scene.lua
--- @brief Game scene and all required events.
----------------------------------------------------------------------------]]--

local Queue = require "core.queue"
local Scene = { name = "scene" }

function Scene:supports(event)
    return self.subscribers[event] ~= nil
end

function Scene:subscribe(event, terminal, name, callback)
    if not self.subscribers[event] then
        self.subscribers[event] = Queue.create()
    end

    local listener = { name = name, terminal = terminal, fn = callback }
    self.subscribers[event]:push(listener)
end

function Scene:unsubscribe(event, name)
    if not self.subscribers[event] then
        error("Event doesn't exist: " .. tostring(event), 2)
    end

    self.subscribers[event] = self.subscribers[event]:filter(function(listener)
        return name ~= listener.name
    end)
end

return {

create = function(name)
    local object = {
        name = name,
        subscribers = {}
    }

    return setmetatable(object, { __index = Scene })
end

}