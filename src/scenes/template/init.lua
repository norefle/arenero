--[[----------------------------------------------------------------------------
- @brief template module.
-
- The main purpose of the template module is to demonstrate
- the idea of implementation of modules for Arenero.
----------------------------------------------------------------------------]]--

--- @todo extract to core

local Color = {}

function Color.new(r, g, b, a)
    -- black opaque by default
    return { r = r or 0, g = g or 0, b = b or 0, a = a or 255 }
end

function Color.unpack(color)
    return color.r, color.g, color.b, color.a
end

--- Module's configuration.
-- @note In the real world module it could/should be separate file.
local Config = {}

-- Global/exported configurations.
Config.name = "Template"
Config.description = "Hello world for Arenero."
Config.version = "0.1.0"
Config.thumbnail = "asset/thumbnail.png"

-- Local configurations.
Config.backgroundColor = Color.new(0, 0, 0, 128)
Config.textColor = Color.new(204, 211, 222, 255)
Config.textMargin = 5

local boundingbox = {
    left = 0, right = love.graphics.getWidth(),
    top = 0, bottom = love.graphics.getHeight()
}

-- Module itself.
local Module = {}

function Module:init()
    self:subscribe("draw", false, self.name, function(dt)
        self:draw(boundingbox)
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

function Module:draw(boundingbox)
    -- Get size of the boundaries.
    local size = {
        width = boundingbox.right - boundingbox.left,
        height = boundingbox.bottom - boundingbox.top
    }

    -- Draw semitransparent black rectangle.
    self.lg.setColor(Color.unpack(Config.backgroundColor))
    self.lg.rectangle("fill", boundingbox.left, boundingbox.top, size.width, size.height)
    -- Write "Hello world" in the middle of the rectangle
    self.lg.setColor(Color.unpack(Config.textColor))
    self.lg.printf(
        "Hello world",
        boundingbox.left + Config.textMargin,
        boundingbox.top + size.height / 2,
        boundingbox.right - Config.textMargin,
        "center"
    )
end

return {

create = function()
    return setmetatable({ }, { __index = Module })
end

}
