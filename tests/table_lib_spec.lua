local table_lib = require("sim.shared.table_lib")

describe("table_lib", function()
	describe("merge", function()
		it("merges two tables correctly", function()
			local res = table_lib.merge({ 1 }, { 2, 3 })

			assert.are.same({ 1, 2, 3 }, res)
		end)
	end)
end)
