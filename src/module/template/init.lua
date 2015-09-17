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

-- Local global vars for quick access to common functions.
local lg -- graphic subsystem.
local out -- debug output

-- Module itself.
local Module = {}

function Module.init(graphics, console)
    lg = graphics
    out = console
end

function Module.load()
    -- Prepare everything here.
end

function Module.draw(boundingbox)
    -- Get size of the boundaries.
    local size = {
        width = boundingbox.right - boundingbox.left,
        height = boundingbox.bottom - boundingbox.top
    }

    -- Draw semitransparent black rectangle.
    lg.setColor(Color.unpack(Config.backgroundColor))
    lg.rectangle("fill", boundingbox.left, boundingbox.top, size.width, size.height)
    -- Write "Hello world" in the middle of the rectangle
    lg.setColor(Color.unpack(Config.textColor))
    lg.printf(
        "Hello world",
        boundingbox.left + Config.textMargin,
        boundingbox.top + size.height / 2,
        boundingbox.right - Config.textMargin,
        "center"
    )

    -- Add text to the debug console.
    out:add("Hello world!")
end

function Module.unload()
    -- Clean up here everything.
end

--[[------------------------------------------------------------------------]]--

--- Exports the table with the list of mandatory fields and functions.
-- @note Life cycle of the module consists of work cycles.
--      Where life cycle is:
--          init [once]
--          work cycle [as many as user decided]
--
--      Where work cycle is
--          load [once per work cycle]
--          draw [as many as system needs to draw something]
--          unload [once per work cycle]
return {

--- The short name of the module.
name = Config.name,

--- More verbose description of the module.
description = Config.description,

--- Version of the module.
version = Config.version,

--- Path to thumbnail icon.
thumbnail = Config.thumbnail,

--- Initialized module before first usage.
-- @param graphics Graphic subsystem (Love graphics API) [table].
-- @param console Console for debug output [table].
-- @note This method is called only once at the very beginning.
init = Module.init,

--- Loads module to work with.
-- @note This method is called every time before work with module.
load = Module.load,

--- Unloads module after work.
-- @note This method is called every time after work with module.
unload = Module.unload,

--- Draws all stuff of the module.
-- @param boundingbox Soft boundaries. [table = { left, right, top, bottom}].
-- @note Soft boundaries are described in coordinates similarly to Love coord system
--      top left corner is { 0; 0 }.
--      Module is highly required to draw all stuff within these boundaries.
draw = Module.draw

}
