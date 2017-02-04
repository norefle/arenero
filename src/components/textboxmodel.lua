local Export = require "core.utils.export"
local Class = require "core.utils.class"
local Component = require "core.component"
local Queue = require "core.queue"

local Model = {}

function Model:init(args)
    self:clear()
end

function Model:foreach(fn)
    self.data:foreach(fn)
end

function Model:clear()
    self.data = Queue.create()
end

function Model:add(pattern, ...)
    self.data:push(string.format(pattern, ...))
end

return Export {
    create = function(engine, entity)
        return Component(engine, entity, "TextBox::Model", Model)
    end
}
