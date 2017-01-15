--[[----------------------------------------------------------------------------
--- @brief Main component of the Shepherd mini game.
----------------------------------------------------------------------------]]--

local Queue = require "core.queue"
local Utils = require "core.utils"
local MapModel = require "scenes.shepherd.states.map"
local ActorModel = require "scenes.shepherd.states.actor"
local MapView = require "scenes.shepherd.views.map"

local Shepherd = {}

function Shepherd:init()
    self.player = self.engine:actor(ActorModel.create(22), "player", 10, function() end)
    self.actors = Queue.create{
        self.player,
        self.engine:actor(ActorModel.create(151), "wolf", 2),
        self.engine:actor(ActorModel.create(89), "wolf", 0.5)
    }

    local map = MapModel.create(20, 20)
    self.models["map"] = map
    self.views:push(MapView.create(map, self.actors))
end

function Shepherd:start()
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
    local supported = Queue.create{ "left", "right", "up", "down", "w", "s", "a", "d" }
    local processed = supported
                        :filter(function(expected) return expected == key end)
                        :length() > 0

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
    elseif key == "w" then
        self.player.position = self.player.position - map.columns
    elseif key == "s" then
        self.player.position = self.player.position + map.columns
    elseif key == "a" then
        self.player.position = self.player.position - 1
    elseif key == "d" then
        self.player.position = self.player.position + 1
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

    return setmetatable(object, { __index = Shepherd })
end

}
