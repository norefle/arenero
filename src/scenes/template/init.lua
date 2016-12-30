--[[----------------------------------------------------------------------------
- @brief template scene.
----------------------------------------------------------------------------]]--

local Utils = require "core.utils"

local Config = {}

-- Global/exported configurations.
Config.name = "Template"
Config.description = "Hello world for Arenero."
Config.version = "0.1.0"

-- Local configurations.
Config.backgroundColor = Utils.color(0, 0, 0, 128)
Config.textColor = Utils.color(204, 211, 222, 255)
Config.textMargin = 5

-- Module itself.
local Module = {}

function Module:init()
    self:subscribe("draw", false, self.name, function(...)
        self:draw(...)
    end)

    self:subscribe("keypress", true, self.name, function(dt, key)
        if key == "escape" then
            self.engine:queue("start", "grid")
            return true
        end

        return false
    end)

end

function Module:start()
    self.console:add("Hello world!")
end

function Module:draw(dt, boundingbox)
    local width = boundingbox.right - boundingbox.left
    local height = boundingbox.bottom - boundingbox.top

    -- Draw semitransparent black rectangle.
    self.lg.setColor(Config.backgroundColor:unpack())
    self.lg.rectangle("fill", boundingbox.left, boundingbox.top, width, height)
    -- Write "Hello world" in the middle of the rectangle
    self.lg.setColor(Config.textColor:unpack())
    self.lg.printf(
        "Hello world",
        boundingbox.left + Config.textMargin,
        boundingbox.top + height / 2,
        boundingbox.right - Config.textMargin,
        "center"
    )
end

return {

create = function()
    return setmetatable({ }, { __index = Module })
end

}
