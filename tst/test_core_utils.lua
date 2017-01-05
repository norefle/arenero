local Utils = require "core.utils"

describe("Core utils", function()
    describe("Color", function()
        it("should be available for creation", function()
            local color = Utils.color()
            assert.are.equal("table", type(color))
        end)

        it("should use default value (0x0, 0x0, 0x0, 0xFF)", function()
            local expected = { r = 0, g = 0, b = 0, a = 255 }
            local actual = Utils.color()
            assert.are.same(expected, actual)
        end)

        it("should unpack to the initial values", function()
            local expected = { 10, 20, 30, 40 }

            local color = Utils.color(unpack(expected))
            local actual = { color:unpack() }

            assert.are.same(expected, actual)
        end)
    end)

end)
