assert( xpcall( require 'busted.runner'(), require'stacktraceplus'.stacktrace ) )

local Rectangle = require 'Rectangle'
describe("2D rectangle class", function()
	it("tests single vertex collision", function()
		assert.is_false(
			Rectangle:new(0,0,1,1):checkOverlap(
				Rectangle:new(1,1,1,1)
			)
		)
	end)
	it("tests single vertex collision in reverse order",function()
		assert.is_false(
			Rectangle:new(1,1,1,1):checkOverlap(
				Rectangle:new(0,0,1,1)
			)
		)
	end)
	it("test overlap clearance",function()
		assert.is_true(
			Rectangle:new(0,0,1,1):checkOverlap(
				Rectangle:new(1.1,1.1,1,1)
			)
		)
	end)
	local a, b = Rectangle:new(0,0,2,2), Rectangle:new(1,1,3,3)
	it("tests intersection operation",function()
		assert.is.truthy( a:intersection( b ) == Rectangle:new(1,1,1,1) )
	end)
	it("tests union operation",function()
		assert.is.truthy( a:union( b ) == Rectangle:new(0,0,3,3) )
	end)
end)
