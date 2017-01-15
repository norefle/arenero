local EventSystem = require "core.eventsystem"

describe("Event system", function()
    it("should be available for creation", function()
        local system = EventSystem()
        assert.is_not.falsy(system)
    end)

    it("should have empty subscribers queue by default", function()
        local system = EventSystem("Events")
        assert.are.equal(0, #system.subscribers)
    end)

    describe("support", function()
        it("should return false after creation", function()
            local system = EventSystem("empty")

            assert.is_false(system:supports("draw"))
        end)

        it("should return true for registered event", function()
            local system = EventSystem("has-ping")
            system:subscribe("ping", false, "ping", function() end)

            assert.is_true(system:supports("ping"))
        end)
    end)
end)
