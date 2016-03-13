--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
local function getHitSound(hitSound)
	local pathHitSound = nil
	local out = {{}, 0}
	
	for i,format in pairs(data.audioFormats) do
		for i,file in pairs(hitSound[1]) do
			if love.filesystem.exists(data.beatmap.path .. "/" .. file .. "." .. format) then
				pathHitSound = data.beatmap.path .. "/" .. file .. "." .. format
				out[2] = hitSound[2]
				table.insert(out[1], pathHitSound)
			elseif love.filesystem.exists(data.config.skinname .. "/" .. file .. "." .. format) then
				pathHitSound = data.config.skinname .. "/" .. file .. "." .. format
				out[2] = hitSound[2]
				table.insert(out[1], pathHitSound)
			end
		end
	end
	
	if filename == "blank" then
		out = {{"res/blank.ogg"}, 0}
	end
	
	return out
end

return getHitSound