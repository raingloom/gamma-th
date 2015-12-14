--[[
	Coordinate system used:
		x--> X goes from left to right
	y			 Y goes from top to bottom
	|
	V
	This corresponds to the reading direction of English text and screen coordinates.	 
	
	Methods should be pretty self-explanatory.
]]

local prefix = ... and (...):match '(.-%.?)[^%.]+$' or ''
local Rectangle = require(prefix .. 'RectangleStruct'):subclass'Rectangle'


local max, min = math.max, math.min


function Rectangle:translate( x, y )
	self.x = self.x + x
	self.y = self.y + y
	return self
end


function Rectangle:scale( x, y )
	y = y or x
	self.w = self.w * x
	self.h = self.h * y
end


function Rectangle:getCenter()
	return self.x + self.w/2, self.y + self.h/2
end


--[[--Converts a rectangle to four coordinates
	Returns four number, which form two coordinate pairs: the top left corner and the bottom right one.
	@return x,y, x+w,y+h
]]
function Rectangle:toPointPair()
	local x, y = self.x, self.y
	return x, y, x + self.w, y + self.h
end


function Rectangle.static.fromPointPair( x1, y1, x2, y2 )
	return Rectangle:new( x1, y1, x2-x1, y2-y1 )
end


---Checks whether two rectangles are touching.
-- @return true if there is no overlap, false otherwise
function Rectangle:checkOverlap( other )
	local xi, yi
	if self.x < other.x then
		xi = self.x + self.w < other.x
	else
		xi = other.x + other.w < self.x
	end
	if self.y < other.y then
		yi = self.y + self.h < other.y
	else
		yi = other.y + other.h < self.y
	end
	return xi and yi
end


---Creates a rectangle that encompasses the two other rectangles
-- @tparam Rectangle other the other rectangle
-- @return a new rectangle
function Rectangle:union( other )
	return Rectangle.new(
		min( self.x, other.x ),
		min( self.y, other.y ),
		max( self.w, other.w ),
		max( self.h, other.h )
	)
end



function Rectangle:intersection( other )
	local sx1, sy1, sx2, sy2 = self:toPointPair()
	local ox1, oy1, ox2, oy2 = other:toPointPair()
	return Rectangle.fromPointPair( max( sx1, oy1 ), max( sy1, oy1 ), min( sx2, ox2 ), min( sy2, oy2 ) )
end


function Rectangle:area()
	return (self.w)*(self.h)
end


function Rectangle:unpack()
	return self.x, self.y, self.w, self.h
end


return Rectangle
