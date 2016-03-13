--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
local function printDebugInfo()
	local hud = data.hud
	local dt = data.dt
	
	lg.setFont(luaMania.data.ui.songlist.font)
		
	lg.setColor(255, 255, 255, 255)
	lg.print(
		"FPS: "..lt.getFPS().."\n"..
		"startTime: " .. data.stats.currentTime .. "\n" ..
		"speed: " .. data.config.speed .. "\n" ..
		"speed multiplier: " .. data.stats.speed .. "\n" ..
		"offset: " .. data.config.offset .. "\n" ..
		"autoplay: " .. data.autoplay .. "\n" ..
		"pitch: " .. data.config.pitch .. "\n" ..
		"HitObjects: " .. data.beatmap.objects.count .. "\n" ..
		"miss: " .. data.stats.hits[6] .. "\n" ..
		"50: " .. data.stats.hits[5] .. "\n" ..
		"100: " .. data.stats.hits[4] .. "\n" ..
		"200: " .. data.stats.hits[3] .. "\n" ..
		"300: " .. data.stats.hits[2] .. "\n" ..
		"MAX: " .. data.stats.hits[1] .. "\n" ..
		"MaxCombo: " .. data.stats.maxcombo .. "\n" ..
		"Combo: " .. data.stats.combo .. "\n"
		, 0, 0, 0, 1, 1)
	lg.setColor(255, 255, 255, 255)
end

return printDebugInfo