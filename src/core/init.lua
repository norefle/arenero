--[[----------------------------------------------------------------------------
----------------------------------------------------------------------------]]--

local Scene = require "core.scene"
local Queue = require "core.queue"
local Console = require "core.console"

local Core = {}

function Core:scene(name)
    local selected = self.scenes[name]
    if not selected then
        local loaded, sceneObject = pcall(require, "scenes." .. name)
        if not loaded then
            error("Invalid scene name: " .. tostring(name), 2)
        end
        selected = sceneObject.create(Scene.create(name), self.graphics, self.console)
        selected:init()
        self.scenes[name] = selected
    end

    return selected
end

function Core:start(name)
    local selected = self.scenes[name]
    if selected then
        -- Emit event about closing scene
        self.active = selected
    end
end

function Core:emit(event, ...)
    local args = { ... }
    local continue = true
    if self.active and self.active:supports(event) then
        self.active.subscribers[event]:foreach(function(listener)
            if continue then
                local processed = listener.fn(unpack(args))
                continue = not (listener.terminal and processed)
            end
        end)
    end

    if continue and self.subscribers[event] then
        self.subscribers[event]:foreach(function(listener)
            if continue then
                local processed = listener.fn(unpack(args))
                continue = not (listener.terminal and processed)
            end
        end)
    end
end

function Core:subscribe(event, terminal, name, callback)
    local listener = { name = name, terminal = terminal, fn = callback }
    local subscribers = self.subscribers[event]
    if not subscribers then
        subscribers = Queue.create()
        self.subscribers[event] = subscribers
    end
    subscribers:push(listener)
end

function Core:unsubscribe(event, name)
    if self.subscribers[event] then
        self.subscribers[event] = self.subscribers[event]:filter(function(listener)
            return listener.name ~= name
        end)
    end
end

function Core:queue(event, ...)
    if not self.events then
        error("There is no queue to add an event to: " .. event, 2)
    end

    self.events:push({ name = event, args = { ... }})
end

function Core:pump(dt)
    if not self.events then
        error("There are no events to pump trough.", 2)
    end

    local events = self.events
    self.events = Queue.create()
    events:foreach(function(event)
        self:emit(event.name, unpack(event.args))
    end)
end

return {

create = function(scenes)
    scenes = scenes or {}
    local object = {
        scenes = scenes,
        subscribers = {},
        events = Queue.create(),
        console = Console.create(),
        graphics = love.graphics
    }

    return setmetatable(object, { __index = Core } )
end

}