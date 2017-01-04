--[[----------------------------------------------------------------------------
----------------------------------------------------------------------------]]--

local Queue = require "core.queue"
local Utils = require "core.utils"

local Manager = {
    name = "actorManager"
}

function Manager:init()
    self.engine:subscribe("update", false, self.name, function(...)
        self:update(...)
    end)
end

function Manager:update(dt)
    self.actors:foreach(function(actor)
        actor.delta = actor.delta + dt
        if actor.threshold <= actor.delta then
            actor.role(actor, actor.delta)
            actor.delta = 0
        end
    end)
end

local Actor = {
    name = "Actor",
    delta = 0,
    threshold = 0,
    role = function(actor, dt) end
}

function Manager:actor(base, name, threshold, role)
    local object = Utils.clone(base)
    object.name = name
    object.threshold = threshold
    if role then
        object.role = role
    end

    local actor = setmetatable(object, { __index = Actor })
    self.actors:push(actor)

    return actor
end

return {

create = function(engine)
    local object = {
        engine = engine,
        actors = Queue.create()
    }

    return setmetatable(object, { __index = Manager })
end

}
