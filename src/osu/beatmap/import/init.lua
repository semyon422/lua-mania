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
		elseif blockName == "Events" and trim(line) ~= "" then
			
		elseif blockName == "TimingPoints" and trim(line) ~= "" then
			table.insert(self.timingPoints, self.TimingPoint:new():import(line))
			local current = self.timingPoints[#self.timingPoints]
			local prev = self.timingPoints[#self.timingPoints - 1]
			if #self.timingPoints == 1 and current.startTime > 0 then
				self.timingPoints[2] = current
				self.timingPoints[1] = self.TimingPoint:new():import(line)
				self.timingPoints[1].startTime = 0
				self.timingPoints[1].endTime = self.timingPoints[2].startTime - 1
				current = self.timingPoints[2]
				prev = self.timingPoints[1]
			end
			if #self.timingPoints > 1 then
				if not prev.endTime then prev.endTime = current.startTime - 1 end
				if current.timingChange == 0 then
					current.beatLenght = prev.beatLenght
				end
			end
		elseif blockName == "HitObjects" and trim(line) ~= "" then
			table.insert(self.hitObjects, self.HitObject:new():import(line))
		end
	end
	local lastTimingPoint = self.timingPoints[#self.timingPoints]
	local lastHitObject = self.hitObjects[#self.hitObjects]
	lastTimingPoint.endTime = lastHitObject.endTime and lastHitObject.endTime or lastHitObject.startTime
	return self
end

return import
--------------------------------
end

return init