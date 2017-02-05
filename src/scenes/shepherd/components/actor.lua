local Class = require "core.utils.class"
local Export = require "core.utils.export"
local Component = require "core.component"

local Actor = Class("Actor")

function Actor:init(args)
    self.position = args.position
    self.limits = args.limits
    self.threshold = args.threshold
    self.delta = 0
end

function Actor:update(dt)
    self.delta = self.delta + dt
    if self.threshold <= self.delta then
        self:act()
    end
end

function Actor:act()
    if self.position > 10 then
        self.position = self.position - 1
    else
        self.position = self.position + 40
    end
end

return Export {
    create = function(engine, entity, position, limits, threshold)
        return Component(
            engine,
            entity,
            "Actor",
            Actor,
            {
                position = position,
                limits = limits,
                threshold = threshold
            }
        )
    end
}
