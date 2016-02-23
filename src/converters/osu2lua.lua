--[[
lua-mania
Copyright (C) 2016 Semyon Jolnirov (semyon422)

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.
--]]
local function osu2lua(self, cache)
	data.beatmap = {}
	local beatmap = data.beatmap
	
	beatmap.file = io.open(cache.pathFile, "r")
	beatmap.fileLines = {}
	local stage = "info"
	beatmap.info = {}
	beatmap.timing = {}
	beatmap.timing.all = {}
	beatmap.timing.global = nil
	beatmap.timing.current = nil
	beatmap.timing.barlines = {}
	beatmap.objects = {}
	beatmap.objects.clean = {}
	beatmap.objects.current = {}
	beatmap.objects.missed = {}
	beatmap.objects.count = 0
	beatmap.hitSounds = {}
	for line in beatmap.file:lines() do
		table.insert(beatmap.fileLines, line)
	end
	for globalLine,line in pairs(beatmap.fileLines) do
		if stage == "info" then
			if string.sub(line, 1, 17) == "osu file format v" then
				beatmap.info.osuFileFormat = string.sub(line, 18, -1)
			end
			if string.sub(line, 1, 13) == "AudioFilename" then
				beatmap.info.audioFilename = trim(string.sub(line, 15, -1))
			end
			if string.sub(line, 1, 11) == "AudioLeadIn" then
				beatmap.info.audioLeadIn = tonumber(trim(string.sub(line, 13, -1)))
			end
			if string.sub(line, 1, 11) == "PreviewTime" then
				beatmap.info.previewTime = tonumber(trim(string.sub(line, 13, -1)))
			end
			if string.sub(line, 1, 9) == "SampleSet" then
				beatmap.info.sampleSet = trim(string.sub(line, 11, -1))
			end
			if string.sub(line, 1, 4) == "Mode" then
				beatmap.info.mode = trim(string.sub(line, 6, -1))
			end
			if string.sub(line, 1, 12) == "TitleUnicode" then
				beatmap.info.title = trim(string.sub(line, 14, -1))
			end
			if string.sub(line, 1, 13) == "ArtistUnicode" then
				beatmap.info.artist = trim(string.sub(line, 15, -1))
			end
			if string.sub(line, 1, 7) == "Creator" then
				beatmap.info.creator = trim(string.sub(line, 9, -1))
			end
			if string.sub(line, 1, 7) == "Version" then
				beatmap.info.version = trim(string.sub(line, 9, -1))
			end
			if string.sub(line, 1, 6) == "Source" then
				beatmap.info.source = trim(string.sub(line, 8, -1))
			end
			if string.sub(line, 1, 4) == "Tags" then
				beatmap.info.tags = trim(string.sub(line, 6, -1))
			end
			if string.sub(line, 1, 10) == "CircleSize" then
				beatmap.info.keymode = tonumber(trim(string.sub(line, 12, -1)))
			end
			if string.sub(line, 1, 17) == "OverallDifficulty" then
				beatmap.info.overallDifficulty = tonumber(trim(string.sub(line, 19, -1)))
			end
		end
		if string.sub(line, 1, 14) == "[TimingPoints]" then 
			stage = "timing"
		elseif stage == "timing" then
			if trim(string.sub(line, 1, 1)) ~= "[" and trim(explode(",", line)[1]) ~= "" then
				local time = nil
				local endtime = nil
				local value = -100
				local type = 1
				local volume = 100
				
				local raw = explode(",", line)
				
				time = math.ceil(tonumber(raw[1]))
				
				value = tonumber(raw[2])
				if value < 0 then
					type = 1
					value = -100 / value
				elseif value > 0 then
					type = 0
				end
				
				volume = tonumber(raw[6])/100
				table.insert(beatmap.timing.all, {type = type, time = time, endtime = endtime, value = value, volume = volume})
				if #beatmap.timing.all > 1 then
					beatmap.timing.all[#beatmap.timing.all - 1].endtime = time
				end
				--if beatmap.timing.global == nil then
				--	beatmap.timing.global = beatmap.timing.all[time]
				--end
				--if beatmap.timing.current == nil then
				--	beatmap.timing.current = beatmap.timing.all[time]
				--end
			end
		end
		if string.sub(line, 1, 12) == "[HitObjects]" then 
			stage = "objects"
		elseif stage == "objects" then
			if string.sub(line, 1, 1) ~= "[" then 
				interval = 512 / beatmap.info.keymode
				local time = nil
				local key = nil
				local type = {0, 0}
				local endtime = nil
				local hitSound = nil
				local volume = nil
				
				local raw = explode(",", line)
				
				time = tonumber(raw[3])
				if time == nil then break end
				if beatmap.objects.clean[time] == nil then
					beatmap.objects.clean[time] = {}
				end
				
				for newKey = 1, beatmap.info.keymode do
					if tonumber(raw[1]) >= interval * (newKey - 1) and tonumber(raw[1]) < newKey * interval then
						key = newKey
					end
				end
				
				local noteData = explode(":", raw[6])
				
				type[1] = 1
				if raw[4] == "128" then
					type[1] = 2
					endtime = tonumber(noteData[1])
				end
				
				hitSound = self:removeExtension(trim(tostring(noteData[#noteData])))
				volume = tonumber(noteData[#noteData - 1]) / 100
				if hitSound == "" then
					volume = nil
					if beatmap.info.sampleSet == "None" then
						beatmap.info.sampleSet = "Soft"
					end
					if raw[5] == "0" then
						hitSound = string.lower(beatmap.info.sampleSet) .. "-hitnormal"
					end
					if raw[5] == "2" then
						hitSound = string.lower(beatmap.info.sampleSet) .. "-hitwhistle"
					end
					if raw[5] == "4" then
						hitSound = string.lower(beatmap.info.sampleSet) .. "-hitfinish"
					end
					if raw[5] == "8" then
						hitSound = string.lower(beatmap.info.sampleSet) .. "-hitclap"
					end
				end

				if beatmap.hitSounds[key] == nil then beatmap.hitSounds[key] = {} end
				table.insert(beatmap.hitSounds[key], {hitSound, volume})
				
				beatmap.objects.clean[time][key] = {type, time, endtime}
				beatmap.objects.count = beatmap.objects.count + 1
			end
		end
	end
	for time,note in pairs(beatmap.objects.clean) do
		beatmap.timing.all[#beatmap.timing.all].endtime = time + 100
	end
	
	beatmap.path = cache.path
	beatmap.pathFile = cache.pathFile
	beatmap.pathAudio = cache.pathAudio
	if cache.audioFile ~= "virtual" then
		beatmap.audio = love.audio.newSource(cache.pathAudio)
	else
		beatmap.audio = nil
	end
end

return osu2lua
