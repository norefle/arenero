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
        local actual = Class("test")
        assert.are.equal("test", actual.__type)
    end)

    it("should inherit new class from 'super'", function()
        local Parent = {}
        Parent.name = "Parent"
        Parent.is = function(self) return self.name end

        local subclass = Class { name = "Child", extends = Parent }

        assert.are.equal("function", type(subclass.is))
        assert.are.equal(Parent.name, subclass:is())
    end)

    it("should return nil for non existed fields in both class and its parent", function()
        local parent = { }
        local child = Class { name = "child", extends = parent }

        assert.is.falsy(child.nonExisted)
    end)

    it("should support inheritance depth more that 2", function()
        local Root = Class("root")
        Root.is = function(self) return self.__type .. "#from root" end
        local Middle = Class{ name = "node", extends = Root }
        Middle.is = function(self) return self.__type .. "#from middle#" .. self.__super:is() end

        local leaf = Class { name = "leaf", extends = Middle }

        assert.are.equal("leaf", leaf.__type)
        assert.are.equal("leaf#from middle#node#from middle#root#from root", leaf:is())
    end)

    it("should use instance object instead of creating one", function()
        local Instance = {
            name = "instance",
            is = function(self) return self.name end
        }

        local object = Class { name = "Instance", instance = Instance }

        assert.are.equal(Instance.name, object:is())
    end)

    it("should copy instance object instead of using it", function()
        local Instance = { name = "instance" }
        local object = Class { name = "instance", instance = Instance }

        assert.is.falsy(Instance.__type)
        assert.is.falsy(getmetatable(Instance))
    end)

    it("should call 'init' method of instance object if it exists", function()
        local called = 0
        local Instance = { init = function() called = called + 1 end }

        local object = Class { name = "init", instance = Instance }

        assert.are.equal(1, called)
    end)

    it("should not call 'init' if it's not function", function()
        local called = 0
        local _mt = { __call = function() called = called + 1 end }
        local Instance = { init = { } }
        setmetatable(Instance.init, _mt)

        local object = Class { name = "callable_mt", insatnce = Instance }

        assert.are.equal(0, called)
    end)
end)
