--[[----------------------------------------------------------------------------
--- @file scene.lua
--- @brief Game scene and all required events.
----------------------------------------------------------------------------]]--

local Class = require "core.utils.class"
local Export = require "core.utils.export"
local EventSystem = require "core.eventsystem"

local Scene = EventSystem("Scene")

function Scene:init(args)
    self.engine = args.engine
    self.name = args.name
    self.lg = args.lg
    self.console = args.console
end

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
    local object = Class {
        name = name,
        extends = Scene,
        instance = sceneObject,
        args = {
            engine = engine,
            name = name,
            lg = love.graphics,
            console = output
        }
    }

    return object
end

}
