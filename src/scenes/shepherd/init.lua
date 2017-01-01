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
        else
            return self:keypress(dt, key)
        end
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

function Shepherd:keypress(dt, key)
    local map = self.models["map"]
    local position = map.current

    -- @todo Use key manager
    local processed = key == "left" or key == "right" or key == "up" or key == "down"
    local currentColumn = position % map.rows
    if currentColumn == 0 then
        currentColumn = map.columns
    end
    if key == "left" then
        if 1 < currentColumn then
            position = position - 1
        end
    elseif key == "right" then
        if currentColumn < map.columns then
            position = position + 1
        end
    elseif key == "up" then
        position = Utils.clap(position, currentColumn, position - map.columns)
    elseif key == "down" then
        position = Utils.clap(position, position + map.columns, map.columns * (map.rows - 1) + currentColumn)
    end

    self.console:add("Position %d -> %d column %d -> %d", map.current, position, currentColumn, position % map.rows)

    map.current = position

    return processed
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
