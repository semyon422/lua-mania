local init = function(Beatmap, lmx)
--------------------------------
local import = function(self, filePath)
	local breakedPath = explode("/", filePath)
	self.mapFileName = breakedPath[#breakedPath]
	self.mapPath = string.sub(filePath, 1, #filePath - #self.mapFileName - 1)
	
	return self
end

return import
--------------------------------
end

return init
