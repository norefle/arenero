--[[----------------------------------------------------------------------------
----------------------------------------------------------------------------]]--

local Class = require "core.utils.class"
local Component = require "core.component"
local Export = require "core.utils.export"
local Queue = require "core.queue"

local System = Class("EventSystem")

function System:init(args)
    self.engine = args.engine

    self.subscribers = { }
    self.supported = args.supported
    self.supported:foreach(function(event)
        self.subscribers[event] = Queue.create()
    end)

    self.events = Queue.create()
end

function System:supports(event)
    return self.subscribers[event] ~= nil
end

function System:subscribe(event, terminal, name, callback)
    if not self.subscribers[event] then
        error("Unsupported event type " .. event .. " for the system " .. self.name, 2)
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

function System:queue(event, ...)
    if not self.events then
        error("There is no queue to add an event to: " .. event, 2)
    end

    self.events:push({ name = event, args = { ... }})
end

function System:emit(event, dt, ...)
    if not self.subscribers[event] then
        error("Can't emit unsupported event " .. event, 2)
    end

    local args = { dt, ... }
    local continue = true
    self.subscribers[event]:foreach(function(listener)
        if continue then
            local processed = listener.fn(
                unpack(args))
            continue = not (listener.terminal and processed)
        end
    end)
end

function System:pump(dt)
    if not self.events then
        error("There are no events to pump trough.", 2)
    end

    local events = self.events
    self.events = Queue.create()

    events:foreach(function(event)
        self:emit(event.name, dt, unpack(event.args))
    end)
end

function System:addComponent(component, terminal)
    self.supported:foreach(function(event)
        if type(component[event]) == "function" then
            self:subscribe(event, terminal, component.name, function(...)
                return component[event](component, ...)
            end)
        end
    end)
end

return Export {
    create = function(engine, name, object, supported)
        assert(type(engine) == "table", "Can't create an event system with empty engine.", 2)
        assert(type(name) == "string", "Can't create a nameless event system.", 2)
        assert(type(supported) == "table", "Can't create an event system without supported events.", 2)
        return Class {
            name = name,
            extends = System,
            instance = object,
            args = {
                engine = engine,
                supported = supported
            }
        }
    end
}
