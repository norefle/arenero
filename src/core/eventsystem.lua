--[[----------------------------------------------------------------------------
----------------------------------------------------------------------------]]--

local Class = require "core.utils.class"
local Export = require "core.utils.export"
local Queue = require "core.queue"

local System = Class("EventSystem")

function System:init(engine)
    self.subscribers = { }
end

function System:supports(event)
    return self.subscribers[event] ~= nil
end

function System:subscribe(event, terminal, name, callback)
    if not self.subscribers[event] then
        self.subscribers[event] = Queue.create()
    end

    local listener = { name = name, terminal = terminal, fn = callback }
    self.subscribers[event]:push(listener)
end

function System:unsubscribe(event, name)
    if not name then
        for key, queue in pairs(self.subscribers) do
            self.subscribers[key] = queue:filter(function(listener)
                return event ~= listener.name
            end)
        end
    else
        if not self.subscribers[event] then
            error("Event doesn't exist: " .. tostring(event), 2)
        end

        self.subscribers[event] = self.subscribers[event]:filter(function(listener)
            return name ~= listener.name
        end)
    end
end


return Export {
    create = function(name, object)
        return Class(name, System, object)
    end
}
