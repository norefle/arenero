local Config = {

tiles = { "blank" },
size = 64,
viewport = { columns = 10, rows = 5 },

}

local Map = { }

function Map:draw(boundingbox)
    local screenWidth = boundingbox.right - boundingbox.left
    local screenHeight = boundingbox.bottom - boundingbox.top
    local viewportWidth = Config.viewport.columns * Config.size
    local viewportHeight = Config.viewport.rows * Config.size
    local offset = {
        x = math.modf((screenWidth - viewportWidth) / 2, 1),
        y = math.modf((screenHeight - viewportHeight) / 2, 1)
    }

    for i = self.viewport.from, self.viewport.to, 1 do
        local index = i - 1
        local row = math.modf(index / Config.viewport.columns, 2)
        local column = index % Config.viewport.columns
        local x = offset.x + column * Config.size
        local y = offset.y + row * Config.size
        love.graphics.setColor(255, 250, 245, 128)
        love.graphics.rectangle("fill", x, y, Config.size, Config.size)
        love.graphics.setColor(0, 0, 0, 64)
        love.graphics.printf(i, x, y + 15, Config.size, "center")
    end
end

return {

create = function(model)
    local object = { }
    object.model = model
    object.viewport = { from = 1, to = Config.viewport.columns * Config.viewport.rows }

    return setmetatable(object, { __index = Map })
end

}
