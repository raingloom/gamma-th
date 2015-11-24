local RectangleStruct = require 'middleclass' 'RectangleStruct'


function RectangleStruct:initialize( x, y, w, h )
	self.x = x
	self.y = y
	self.w = w
	self.h = h
end


function RectangleStruct:__tostring()
	return 'rectangle{'..self.x..','..self.y..' '..self.w..'x'..self.h..'}'
end


function RectangleStruct:__eq( other )
	return self.x==other.x and self.y==other.y and self.w==other.w and self.h==other.h
end


if _OPT_FFI_STRUCT then
	--Use C struct to save memory and gain speed
	local ok, ffi = pcall( require, 'ffi' )
	if ok then
		local def=[[
			typedef struct rectangle {
				double x, y, w, h;
			} rectangle_t;
		]]
		RectangleStruct.static._cdef = def
		ffi.cdef( def )
		local ffimt = ffi.metatype( 'rectangle_t', RectangleStruct.__instanceDict )
		function RectangleStruct:allocate()
			return ffimt()
		end
	end
end


return RectangleStruct