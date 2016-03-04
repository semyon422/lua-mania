--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
local function playHitsound(self, source)
	for i,file in pairs(source[1]) do
		local hitSound = love.audio.newSource(file)
		local volume = 1
		
		hitSound:setPitch(data.config.pitch)
		
		if source[2] ~= nil then
			volume = source[2]
		elseif data.beatmap.timing.current ~= nil then
			volume = data.beatmap.timing.current.volume
		elseif data.beatmap.timing.global ~= nil then
			volume = data.beatmap.timing.global.volume
		end
		
		hitSound:setVolume(volume)
		hitSound:play()
	end
end

return playHitsound