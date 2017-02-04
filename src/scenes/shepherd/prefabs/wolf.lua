local Entity = require "core.entity"
local Component = require "core.component"
local Export = require "core.utils.export"

local Wolf = {}

return Export {
    create = function(engine)
        local wolf = Entity("Wolf", Wolf)

    end
}

