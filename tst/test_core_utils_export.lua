local Export = require "core.utils.export"

describe("Export", function()
    it("should fail if no table has been provided", function()
        local export = function() return Export("string") end
        assert.has.error(export, "Export expects table as an input")
    end)

    it("should fail if 'create' hasn't been provided", function()
        local export = function() return Export { } end
        assert.has.error(export, "Export expects 'create' function to be defined: nil")
    end)

    it("should wrap 'create' as __call by default", function()
        local called = 0
        local fiction = function() called = called + 1 end
        local export = Export { create = fiction }

        export()

        assert.are.equal(1, called)
    end)

    it("should pass all arguments to 'create' function", function()
        local expected = { 1, 2, "string" }
        local actual = { }
        local create = function(...)
            actual.got = { ... }
        end

        local export = Export { create = create }
        export(1, 2, "string")

        assert.are.same(expected, actual.got)
    end)
end)
