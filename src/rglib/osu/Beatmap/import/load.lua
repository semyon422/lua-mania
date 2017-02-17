local init = function(Beatmap, osu)
--------------------------------
local getValue = function(line, key, tonum)
	if tonum then
		return tonumber(trim(string.sub(line, #key + 2, -1)))
	else
		return trim(string.sub(line, #key + 2, -1))
	end
end

local load = function(self, cache)
	if not cache then
		print("  reading file...")
	end
    -- local file = io.open(self.filePath, "r")
    local file = love.filesystem.newFile(self.filePath)
	file:open("r")
	if not file then error(self.filePath) end
    local fileLines = {}

    local blockName = ""
    for line in file:lines() do
        if line:sub(1,1) == "[" then
            blockName = trim(line):sub(2, -2)
        elseif (blockName == "General" or blockName == "Metadata" or blockName == "Difficulty") and trim(line) ~= "" then
            if startsWith(line, "AudioFilename") then
				self.audioFilename = getValue(line, "AudioFilename")
            elseif startsWith(line, "Mode") then
				local mode = getValue(line, "Mode", true)
				if mode == 3 then
					self.mode = "vsrg"
				else
					self.mode = "unsupported"
				end
            elseif startsWith(line, "Title") and not startsWith(line, "TitleUnicode") then
				self.title = getValue(line, "Title")
            elseif startsWith(line, "Artist") and not startsWith(line, "ArtistUnicode") then
				self.artist = getValue(line, "Artist")
            elseif startsWith(line, "Creator") then
				self.creator = getValue(line, "Creator")
            elseif startsWith(line, "Version") then
				self.mapName = getValue(line, "Version")
            elseif startsWith(line, "Source") then
				self.source = getValue(line, "Source")
            elseif startsWith(line, "CircleSize") then
				self.keymode = getValue(line, "CircleSize", true)
            end			
        elseif blockName == "Events" and trim(line) ~= "" then
            if startsWith(line, "Sample") and not cache then
                table.insert(self.eventSamples, self.EventSample:new({beatmap = self}):import(line))
            elseif not self.backgroundPath and startsWith(line, "0,0,\"") then
                self.backgroundPath = self.mapPath .. "/" .. explode("\"", line)[2]
            end
        elseif blockName == "TimingPoints" and trim(line) ~= "" and not cache then
            table.insert(self.sections.timingPoints, line)
        elseif blockName == "HitObjects" and trim(line) ~= "" and not cache then
            table.insert(self.sections.hitObjects, line)
        end
    end
	file:close()
	if not cache then
		print("  complete!")
	end
end

return load
--------------------------------
end

return init
