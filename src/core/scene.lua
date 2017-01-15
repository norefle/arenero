--[[----------------------------------------------------------------------------
--- @file scene.lua
--- @brief Game scene and all required events.
----------------------------------------------------------------------------]]--

local Class = require "core.utils.class"
local Export = require "core.utils.export"
local EventSystem = require "core.eventsystem"

local Scene = EventSystem("Scene")

function Scene:start()
    self:subscribe("draw", false, self.name, function(...)
        self:draw(...)
    end)
end

function Scene:stop()
    self:unsubscribe(self.name)
end

function Scene:draw()
end

return Export {

create = function(engine, name, sceneObject, output)
    Scene.engine = Scene.engine or engine
    local object = Class(name, Scene, sceneObject)
    object.engine = engine
    object.name = name
    object.lg = love.graphics
    object.console = output

    return object
end

}
