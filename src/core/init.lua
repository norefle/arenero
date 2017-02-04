--[[----------------------------------------------------------------------------
----------------------------------------------------------------------------]]--

local Class = require "core.utils.class"
local Scene = require "core.scene"
local Queue = require "core.queue"
local Console = require "asset.prefabs.console"
local ActorManager = require "core.actormanager"
local SceneManager = require "core.scenemanager"
local EventSystem = require "core.eventsystem"
local Entity = require "core.entity"
local Export = require "core.utils.export"

local Core = {}

function Core:init()
    self.scenes = {}
    self.subscribers = {}
    self.events = Queue.create()
    self.graphics = love.graphics

    self.renderingSystem = EventSystem(self, "Render", nil, Queue.create{ "draw" })

    self.scenemanager = SceneManager.create(self)
    self.scenemanager:init()

    self.actormanager = ActorManager.create(self)
    self.actormanager:init()

    self.console = Console(self, 600, 200)
end

function Core:scene(name)
    local selected = self.scenes[name]
    if not selected then
        local loaded, sceneObject = pcall(require, "scenes." .. name)
        if not loaded then
            error("Invalid scene name: " .. tostring(name) .. " " .. sceneObject, 2)
        end
        selected = Scene(self, name, sceneObject.create(), self.console)
        self.scenes[name] = selected
    end

    return selected
end

function Core:component(kind, component, terminal)
    if kind == "render" then
        self.renderingSystem:addComponent(component, terminal)
        return component
    end

    error("Unsupported kind of component " .. kind, 2)
end

function Core:entity(name, instance)
    return Entity(name, instance)
end

function Core:start(name)
    local selected = self:scene(name)
    if selected then
        self.active = selected
        self.console:clear()
        -- todo replace with event
        if self.active.start then
            self.active:start()
        end
    end
end

function Core:stop()
    if self.active then
        if self.active.stop then
            self.active:stop()
        end
        self:unsubscribe(self.active.name)
        self.scenes[self.active.name] = nil
        self.active = nil
    end
end

function Core:actor(base, name, timeout, callback)
    return self.actormanager:actor(base, name, timeout, callback)
end

function Core:emit(event, dt, ...)
    local args = { dt, ... }
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

    if "draw" == event then
        self.renderingSystem:emit(event, dt, ...)
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

    self.actormanager:update(dt)

    local events = self.events
    self.events = Queue.create()
    events:foreach(function(event)
        self:emit(event.name, dt, unpack(event.args))
    end)

    self.renderingSystem:pump(dt)
end

return Export {

create = function()
    return Class {
        name = "Engine",
        extends = Core
    }
end

}
