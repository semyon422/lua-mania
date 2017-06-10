LuaObject = {}

LuaObject.new = function(self, luaObject)
	local luaObject = luaObject or {}
	setmetatable(luaObject, self)
	self.__index = self
	
	return luaObject
end