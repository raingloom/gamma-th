--[[--
	A relational 2D transform library.
]]


local Transform2 = require 'middleclass' 'Transform2'
local Vector2 = require 'Vector2'
Transform2.__index = Transform2


local objects = {}
Transform2.static.objects = objects--debug access


function Transform2:__tostring ( )
	return string.format (
		"transform id(%d) offset({%f,%f},%f) global({%f,%f},%f) parentId(%d)",
		self.id,
		self.position.x, self.position.y,
		self.radian,
		self.globalPosition.x, self.globalPosition.y,		 self.globalRadian,
		self.parent and self.parent.id or 0
	)
end


function Transform2:initialize( position, radian, parent )
	local id = #objects + 1
	local ret = setmetatable (
		{
			id = id,
			position = assert ( position, "No position given" ),
			radian = radian or 0,
			parent = false,
			children = {},
		},
		Transform2
	)
	ret.globalPosition.x = ret.position.x
	ret.globalPosition.y = ret.position.y
	ret.globalRadian = ret.radian
	objects [id] = ret
	if parent then
		ret:setParent ( parent )
	end
	return ret
end


--[[--
	Traverses all offsprings and calls a function on all
	Function paramaters: ( Transform self, Transform parent, ... )
		self: the child on which the function is called
		parent: the parent that propagated the function
	@param function func the function to be called
	@param ... optional arguments that `func` will take
	@see recurseAncestors
]]
function Transform2:recurseOffsprings ( func, ... )
	local children = self.children
	if children then
		for child in pairs ( children ) do
			func ( child, self, ... )
			child:recurseOffsprings ( func, ... )
		end
	end
end


--[[--
	Traverses all ancestors and calls a function on all of them
	Function parameters: ( Transform self, Transform child, ... )
		self: the parent
		child: the child that propagated the function
	@param function func the function to be called
	@param ... optional arguments that `func` will take
	@see recurseOffsprings
]]
function Transform2:recurseAncestors ( func, ... )
	local parent = self.parent
	if parent then
		func ( parent, self, ... )
		parent:recurseAncestors ( func, ... )
	end
end



function Transform2:setParent ( parent, norefresh )
	local prev = self.parent
	if prev then
		prev.children [ self ] = nil
	end
	self.parent = parent
	if parent then
		parent.children [ self ] = true
	end
	if not norefresh then
		self:refresh ( )
	end
	return parent
end


function Transform2:setPosition ( position, norefresh )
	self.position = position
	if not norefresh then
		self:refresh ( )
		self:recurseOffsprings (
			function ( child )
				child:refresh ( )
			end
		)
	end
end


function Transform2:setRadian ( radian, norefresh )
	self.radian = radian
	if not norefresh then
		self:refresh ( )
		self:recurseOffsprings (
			function ( child )
				child:refresh ( )
			end
		)
	end
end


function Transform2:refresh ( )
	local parent = self.parent
	if parent then
		local parentRadian = parent.radian
		self.globalPosition = parent.globalPosition + self.position:rotate ( parentRadian )
		self.globalRadian = self.radian + parentRadian
	end
end


function Transform2:refreshChildren ( )
	self:recurseOffsprings (
		function ( child )
			child:refresh ( )
		end
	)
end


return Transform2