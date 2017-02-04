local Queue = require "core.queue"

describe("Queue", function()
    it("should be empty on create", function()
        local queue = Queue.create()

        assert.are.equal(0, queue:length())
    end)
end)
