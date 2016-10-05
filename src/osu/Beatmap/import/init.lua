local init = function(Beatmap, osu)
--------------------------------
local import = function(self, filePath)
	local breakedPath = explode("/", filePath)
	self.mapFileName = breakedPath[#breakedPath]
	self.mapPath = string.sub(filePath, 1, #filePath - #self.mapFileName - 1)
	
	self.hitSoundsRules = {
		formats = {"wav", "mp3", "ogg"},
		paths = {self.mapPath}
	}
	
	local file = io.open(filePath, "r")
	local fileLines = {}

	local blockName = ""
	for line in file:lines() do
		if line:sub(1,1) == "[" then
			blockName = trim(line):sub(2, -2)
		elseif blockName ~= "Events" and blockName ~= "TimingPoints" and blockName ~= "HitObjects" then
			if string.sub(line, 1, #("AudioFilename")) == "AudioFilename" then
				self.audioFilename = trim(string.sub(line, #("AudioFilename") + 2, -1))
			elseif string.sub(line, 1, #("CircleSize")) == "CircleSize" then
				self.keymode = tonumber(string.sub(line, #("CircleSize") + 2, -1))
			end
		elseif blockName == "Events" and trim(line) ~= "" then
			if string.sub(line, 1, 6) == "Sample" then
				table.insert(self.eventSamples, self.EventSample:new({beatmap = self}):import(line))
			end
		elseif blockName == "TimingPoints" and trim(line) ~= "" then
			table.insert(self.timingPoints, self.TimingPoint:new({beatmap = self}):import(line))
			local current = self.timingPoints[#self.timingPoints]
			local prev = self.timingPoints[#self.timingPoints - 1]
			
			if #self.timingPoints == 1 then
				self.baseBeatLength = current.beatLength
				if current.startTime > 0 then
					self.timingPoints[2] = current
					self.timingPoints[2].index = 2
					self.timingPoints[1] = self.TimingPoint:new({beatmap = self}):import(line)
					self.timingPoints[1].index = 1
					self.timingPoints[1].startTime = 0
					self.timingPoints[1].endTime = self.timingPoints[2].startTime - 1
					current = self.timingPoints[2]
					prev = self.timingPoints[1]
				end
			end
			if #self.timingPoints > 1 then
				if prev.endTime == prev.startTime then prev.endTime = current.startTime - 1 end
				if current.inherited then
					current.beatLenght = prev.beatLenght
				else
					self.baseTimingPoint = current
				end
			end
		elseif blockName == "HitObjects" and trim(line) ~= "" then
			table.insert(self.hitObjects, self.HitObject:new({beatmap = self}):import(line))
		end
	end
	self.timingPoints[#self.timingPoints].endTime = math.huge
	return self
end

return import
--------------------------------
end

return init
