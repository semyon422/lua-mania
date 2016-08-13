local init = function(Beatmap, osu)
--------------------------------
local import = function(self, filePath)
	local breakedPath = explode("/", filePath)
	local mapFileName = breakedPath[#breakedPath]
	breakedPath = nil
	local mapPath = string.sub(filePath, 1, #filePath - #mapFileName)
	self:set("mapFileName", mapFileName)
	self:set("mapPath", mapPath)
	
	local file = io.open(filePath, "r")
	local fileLines = {}
	
	local blockName = ""
	for line in file:lines() do
		if line:sub(1,1) == "[" then
			blockName = line:sub(2, -2)
		elseif blockName ~= "Events" and blockName ~= "TimingPoints" and blockName ~= "HitObjects" then
			local colon = line:find(":")
			if colon then
				local key = trim(line:sub(1, colon - 1))
				local value = trim(line:sub(colon + 1, -1))
				self:set(key, tonumber(value) or value)
			end
		elseif blockName == "Events" then
			
		elseif blockName == "TimingPoints" then
		
		elseif blockName == "HitObjects" then
			table.insert(self.hitObjects, self.HitObject:new():import(line))
		end
	end
	return self
end

return import
--------------------------------
end

return init