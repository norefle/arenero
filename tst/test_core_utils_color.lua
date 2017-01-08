local Color = require "core.utils.color"

describe("Core utils", function()
    describe("Color", function()
        it("should be available for creation", function()
            local color = Color()
            assert.are.equal("table", type(color))
            assert.are.equal("Color", color.__type)
        end)

        it("should use default value (0x0, 0x0, 0x0, 0xFF)", function()
            local expected = { r = 0, g = 0, b = 0, a = 255 }
            local actual = Color()
            assert.are.same(expected, actual)
        end)

        it("should unpack to the initial values", function()
            local expected = { 10, 20, 30, 40 }

            local color = Color(unpack(expected))
            local actual = { color:unpack() }

            assert.are.same(expected, actual)
        end)
    end)

end)
