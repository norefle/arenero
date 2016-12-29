--[[----------------------------------------------------------------------------
----------------------------------------------------------------------------]]--

local Manager = {}

function Manager:init()
    self.engine:subscribe("start", true, "sceneManager", function(...)
        return self:begin(...)
    end)

    self.engine:subscribe("loading", true, "sceneManager", function(...)
        return self:progress(...)
    end)

    self.engine:subscribe("startScene", true, "sceneManager", function(...)
        return self:done(...)
    end)

    self.engine:subscribe("draw", false, "sceneManager", function(...)
        return self:draw(...)
    end)
end

function Manager:begin(dt, name)
    self.engine:stop()
    local selected = self.engine:scene(name)
    if selected then
        self.scene = selected
        self.engine:queue("loading", 100)
    end

    return true
end

function Manager:progress(dt, counter)
    self.counter = counter + dt * 100
    if self.counter < 100 then
        self.engine:queue("loading", self.counter)
    else
        self.engine:queue("startScene", self.scene.name)
    end

    return true
end

function Manager:done(dt, scene)
    self.scene = nil
    self.counter = nil
    self.engine:start(scene)

    return true
end

function Manager:draw()
    if self.scene and self.counter then
        love.graphics.printf(
            "Loading: " .. self.scene.name .. " " .. tostring(self.counter) .. "%",
            100,
            100,
            500,
            "left"
        )
    end

    return true
end

return {

create = function(engine)
    local object = { }
    object.engine = engine
    object.scene = nil

    return setmetatable(object, { __index = Manager })
end

}
