local Class = require "core.utils.class"

describe("Core class", function()
    it("should create empty class", function()
        local actual = Class()
        assert.are.equal("table", type(actual))
    end)

    it("should set type as 'unknown' if no name has been provided", function()
        local actual = Class()
        assert.are.equal("unknown", actual.__type)
    end)

    it("should return nil for non existed fields", function()
        local pure = Class()
        assert.is.falsy(pure.some)
    end)

    it("should use name as type", function()
        local actual = Class "test"
        assert.are.equal("test", actual.__type)
    end)

    it("should inherit new class from 'super'", function()
        local Parent = {}
        Parent.name = "Parent"
        Parent.is = function(self) return self.name end

        local subclass = Class("Child", Parent)

        assert.are.equal("function", type(subclass.is))
        assert.are.equal(Parent.name, subclass:is())
    end)

    it("should return nil for non existed fields in both class and its parent", function()
        local parent = { }
        local child = Class("child", parent)

        assert.is.falsy(child.nonExisted)
    end)

    it("should support inheritance depth more that 2", function()
        local Root = Class("root")
        Root.is = function(self) return self.__type .. "#from root" end
        local Middle = Class("node", Root)
        Middle.is = function(self) return self.__type .. "#from middle#" .. self.__super:is() end

        local leaf = Class("leaf", Middle)

        assert.are.equal("leaf", leaf.__type)
        assert.are.equal("leaf#from middle#node#from middle#root#from root", leaf:is())
    end)
end)
