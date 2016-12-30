--[[----------------------------------------------------------------------------
--- @brief Main component of the Shepherd mini game.
----------------------------------------------------------------------------]]--

local Queue = require "core.queue"
local Utils = require "core.utils"
local MapModel = require "scenes.shepherd.states.map"
local MapView = require "scenes.shepherd.views.map"

local Shepherd = {}

function Shepherd:init()
    self:subscribe("keypress", true, self.name, function(dt, key)
        if key == "escape" then
            self.engine:queue("start", "grid")
            return true
        elseif key == "left"
            or key == "right"
            or key == "up"
            or key == "down"
        then
            local map = self.models["map"]
            local position = map.current
            local size = map.columns * map.rows
            if key == "left" then
                position = Utils.clap(position, 1, position - 1)
            elseif key == "right" then
                position = Utils.clap(position, position + 1, size)
            elseif key == "up" then
                position = Utils.clap(position, 1, position - map.columns)
            elseif key == "down" then
                position = Utils.clap(position, position + map.columns, size)
            end

            map.current = position

            self.console:add("Position: " .. position)

            return true
        end

        return false
    end)

    self:subscribe("draw", false, self.name, function(...)
        self:draw(...)
    end)
end

function Shepherd:draw(dt, boundingbox)
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

    local map = MapModel.create(20, 20)
    object.models["map"] = map
    object.views:push(MapView.create(map))

    return setmetatable(object, { __index = Shepherd })
end

}
