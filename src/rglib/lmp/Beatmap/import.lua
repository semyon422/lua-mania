local init = function(Beatmap, lmp)
--------------------------------
local import = function(self, filePath)
	local breakedPath = explode("/", filePath)
	self.mapFileName = breakedPath[#breakedPath]
	self.mapPath = string.sub(filePath, 1, #filePath - #self.mapFileName - 1)
	
	local status, result = pcall(loadfile(filePath))
	result(self)

	return self
end

return import
--------------------------------
end

return init

