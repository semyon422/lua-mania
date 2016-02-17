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
local function lm2lua(self, cache)

	data.beatmap = {}
	local beatmap = data.beatmap
	
	beatmap.info = {}
	beatmap.timing = {}
	beatmap.objects = {}
	beatmap.objects.clean = {}
	beatmap.objects.current = {}
	beatmap.objects.missed = {}
	beatmap.objects.count = 0
	beatmap.hitSounds = {}
	
	beatmap.path = cache.path
	beatmap.pathFile = cache.pathFile
	beatmap.pathAudio = cache.pathAudio
	
	beatmap.audio = love.audio.newSource(cache.pathAudio)
	
	local file = io.open(beatmap.pathFile, "r")
	local tblLines = {}
	for line in file:lines() do
		table.insert(tblLines, line)
	end
	file:close()
	
	local eventsLine = 0
	for n,line in pairs(tblLines) do
		if string.sub(line, 1, 13) == "audioFilename" then
			beatmap.audioFile = string.sub(line, 15, -1)
		end
		if string.sub(line, 1, 2) == "KM" then
			beatmap.info.keymode = tonumber(string.sub(line, 4, -1))
		end
		if string.sub(line, 1, 5) == "title" then
			beatmap.info.title = string.sub(line, 7, -1)
		end
		if string.sub(line, 1, 6) == "events" then
			eventsLine = n
			break
		end
	end
	
	beatmap.timing.offset = 0
	beatmap.timing.BPM = 120
	beatmap.timing.volume = 30
	beatmap.timing.beatDivisor = 12
	local beatTime = 60 * 1000 / beatmap.timing.BPM
	local tact = 0
	local subTact = 0
	local key = 1
	local type = {1,0}
	local time = 0
	local lenght = 0
	local endtime = 0
	local hitSound = nil
	local image = nil
	local tempLine = {}
	local tempKey = {}
	
	for line = eventsLine + 1, #tblLines do
		if string.sub(tblLines[line], 1, 1) == "#" then
			tempLine = explode(",", tblLines[line])
			if tempLine[1] ~= nil then
				tact = tonumber(string.sub(tempLine[1], 2, -1))
			end
			if tempLine[2] ~= nil then
				beatmap.timing.offset = tonumber(string.sub(tempLine[2], 1, -1))
			end
			if tempLine[3] ~= nil then
				beatmap.timing.BPM = tonumber(string.sub(tempLine[3], 1, -1))
				beatTime = 60 * 1000 / beatmap.timing.BPM
			end
			if tempLine[4] ~= nil then
				beatmap.timing.volume = tonumber(string.sub(tempLine[4], 1, -1))
			end
			if tempLine[5] ~= nil then
				beatmap.timing.beatDivisor = tonumber(string.sub(tempLine[5], 1, -1))
			end
			tempLine = {}
		else
			tempLine = explode(",", tblLines[line])
			if tempLine[1] ~= nil then
				subTact = tonumber(string.sub(tempLine[1], 1, -1))
			end
			time = math.floor(beatmap.timing.offset + (tact + subTact / beatmap.timing.beatDivisor) * 4 * beatTime)
			beatmap.objects.clean[time] = {}
			for ikey = 1, #tempLine - 1 do
				tempKey = explode(":", tempLine[ikey + 1])
				if tempKey[1] ~= nil then
					key = tonumber(string.sub(tempKey[1], 1, -1))
				end
				if tempKey[2] ~= nil then
					type = {tonumber(string.sub(tempKey[2], 1, -1)), 0}
				end
				if tempKey[3] ~= nil then
					lenght = tonumber(string.sub(tempKey[3], 1, -1))
					endtime = math.floor(beatmap.timing.offset + (tact + subTact / beatmap.timing.beatDivisor + lenght / beatmap.timing.beatDivisor) * 4 * beatTime)
				end
				if tempKey[4] ~= nil then
					hitSound = string.sub(tempKey[4], 1, -1)
				end
				if tempKey[5] ~= nil then
					image = tonumber(string.sub(tempKey[5], 1, -1))
				end
				
				if beatmap.hitSounds[key] == nil then beatmap.hitSounds[key] = {} end
				table.insert(beatmap.hitSounds[key], hitSound)
				
				
				tempKey = {}
				beatmap.objects.clean[time][key] = {type, time, endtime, image}
				print(time .. " => " .. type[1])
				type = {1,0}
			end
		end
		if string.sub(line, 1, 2) == "#e" then break end
	end
	
end

return lm2lua