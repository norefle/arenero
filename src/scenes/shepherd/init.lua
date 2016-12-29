--[[----------------------------------------------------------------------------
--- @brief Main component of the Shepherd mini game.
----------------------------------------------------------------------------]]--

local Queue = require "core.queue"
local MapModel = require "scenes.shepherd.states.map"
local MapView = require "scenes.shepherd.views.map"

local Shepherd = {}

local boundingbox = {
    left = 0, right = love.graphics.getWidth(),
    top = 0, bottom = love.graphics.getHeight()
}

function Shepherd:init()
    self:subscribe("keypress", true, self.name, function(dt, key)
        if key == "escape" then
            self.engine:queue("start", "grid")
            return true
        end

        return false
    end)

    self:subscribe("draw", false, self.name, function(dt)
        self:draw()
    end)
end

function Shepherd:draw()
    self.views:foreach(function(view)
        view:draw(boundingbox)
    end)
end

return {

create = function()
    local object = {
        models = { },
        views = Queue.create()
    }

    local map = MapModel.create(100, 100)
    object.models["map"] = map
    object.views:push(MapView.create(map))

    return setmetatable(object, { __index = Shepherd })
end

}
