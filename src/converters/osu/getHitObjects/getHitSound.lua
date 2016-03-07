--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
local function getHitSound(id)
	local sampleSet = string.lower(data.beatmap.info.sampleSet)
	local hitnormal = sampleSet .. "-hitnormal"
	local hitwhistle = sampleSet .. "-hitwhistle"
	local hitfinish = sampleSet .. "-hitfinish"
	local hitclap = sampleSet .. "-hitclap"
	if id == 0 then
		return {hitnormal}
	elseif id == 2 then
		return {hitwhistle}
	elseif id == 4 then
		return {hitfinish}
	elseif id == 6 then
		return {hitwhistle, hitfinish}
	elseif id == 8 then
		return {hitclap}
	elseif id == 10 then
		return {hitwhistle, hitclap}
	elseif id == 12 then
		return {hitfinish, hitclap}
	elseif id == 14 then
		return {hitwhistle, hitfinish, hitclap}
	end
end

return getHitSound
