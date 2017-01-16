local EventSystem = require "core.eventsystem"
local Queue = require "core.queue"

describe("Event system", function()
    it("shouldn't create new system without engine", function()
        local create = function()
            EventSystem()
        end
        assert.has_error(create, "Can't create an event system with empty engine.")
    end)

    it("shouldn't create new system without name", function()
        local create = function()
            EventSystem({})
        end
        assert.has_error(create, "Can't create a nameless event system.")
    end)

    it("shouldn't create new system without supported events.", function()
        local create = function()
            EventSystem({}, "name")
        end
        assert.has_error(create, "Can't create an event system without supported events.")
    end)

    it("should be available for creation", function()
        local system = EventSystem({}, "name", nil, Queue.create())
        assert.is_not.falsy(system)
    end)

    it("should have empty subscribers queue by default", function()
        local system = EventSystem({}, "Events", nil, Queue.create())
        assert.are.equal(0, #system.subscribers)
    end)

    describe("support", function()
        it("should return false after creation", function()
            local system = EventSystem({}, "empty", nil, Queue.create())

            assert.is_false(system:supports("draw"))
        end)

        it("should return true for registered event", function()
            local system = EventSystem({}, "has-ping", nil, Queue.create({"ping"}))

            assert.is_true(system:supports("ping"))
        end)
    end)
end)
