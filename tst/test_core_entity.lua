local Entity = require "core.entity"

describe("Entity", function()
    it("shouldn't create a new entity without name", function()
        local create = function()
            Entity({})
        end

        assert.has_error(create, "Can't create a nameless entity.")
    end)

    it("should create an instance with defined name", function()
        local entity = Entity("TestEntity")

        assert.are.equal("Entity", entity.__super.__type)
        assert.are.equal("TestEntity", entity.__type)
    end)

    it("should add component by its name", function()
        local entity = Entity("AddsComponent")
        entity:add("Whatever-Component", {})

        assert.are.equal(1, entity.components:length())
    end)

    it("should fail on add if component already exists", function()
        local entity = Entity("DoubleAdd")
        entity:add("Not-unique", { value = "a" })

        local add = function()
            entity:add("Not-unique", { value = "b" })
        end

        assert.has_error(add, "Component already exists: Not-unique")
    end)

    it("should fail on get if there is no component of requested type", function()
        local entity = Entity("Does'tExist")
        local get = function()
            entity:component("Whatever")
        end

        assert.has_error(get, "Can't find required component: Whatever")
    end)

    it("should return component by its name", function()
        local entity = Entity("ReturnsComponent")
        entity:add("Expected-Component", { key = "value" })

        local actual = entity:component("Expected-Component")

        assert.are.equal("table", type(actual))
        assert.are.equal("value", actual.key)
    end)
end)
