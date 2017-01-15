--[[----------------------------------------------------------------------------
----------------------------------------------------------------------------]]--

return function(export)
    assert(type(export) == "table", "Export expects table as an input", 2)
    assert(
        type(export.create) == "function",
        "Export expects 'create' function to be defined: " .. type(export.create),
        2
    )

    local _mt = {
        __call = function(self, ...)
            return export.create(...)
        end
    }

    return setmetatable(export, _mt)
end
