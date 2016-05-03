local function getHitSound(hitSound)
	local pathHitSound = nil
	local out = {{}, 0}
	
	for _,format in pairs({"wav", "mp3", "ogg"}) do
		for _,file in pairs(hitSound[1]) do
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