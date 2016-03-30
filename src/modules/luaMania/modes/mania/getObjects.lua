--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
local function getObjects()
	local beatmap = luaMania.map
	local currentTime = math.floor(luaMania.audio.source:tell() * 1000)
	local skin = luaMania.ui.skin
	local offset = 0
	local hitPosition = 100
	
	local keymode = luaMania.map.info.keymode
	
	local columns = {}
	for i = 1, keymode do
		local column = skin.modes.mania.keymodes[keymode][i]
		local x = skin.modes.mania.columnStart
		for j = 1, i - 1 do
			x = x + column.width
		end
		columns[i] = {
			column = column,
			x = x
		}
	end
	
	function getY(time)
		return love.graphics.getHeight() - hitPosition - (time - currentTime)
	end
	
	-- for index,point in pairs(luaMania.map.timing.all) do
		-- if point.startTime <= currentTime then
			-- if luaMania.map.timing.current ~= nil then
				-- if luaMania.map.timing.current.startTime <= currentTime and point.startTime <= currentTime and luaMania.map.timing.current.startTime < point.startTime then
					-- luaMania.map.timing.current = point
					-- data.stats.speed = point.velocity
				-- end
			-- else
				-- luaMania.map.timing.current = point
				-- data.stats.speed = point.velocity
			-- end
		-- end
	-- end
	
	local limit = math.ceil(currentTime + love.graphics.getHeight() / (luaMania.config.speed * 0.1))
	for objectTime = currentTime - luaMania.config.hitTiming[#luaMania.config.hitTiming - 1], limit do
		if getY(objectTime) < 0 then
			break
		end
		if luaMania.map.objects.clean[objectTime] ~= nil then
			for j = 1, keymode do
				local note = luaMania.map.objects.clean[objectTime][j]
				if note ~= nil then
					if note.type == 1 then
						if note.state == 0 then
							if objectTime + offset <= currentTime + luaMania.config.hitTiming[#luaMania.config.hitTiming] and objectTime + offset > currentTime - luaMania.config.hitTiming[#luaMania.config.hitTiming - 1] and luaMania.map.objects.current[j] == nil then
								luaMania.map.objects.current[j] = note
								luaMania.map.objects.clean[objectTime][j] = nil
							else
								table.insert(luaMania.graphics.objects[3], {
									class = "drawable",
									color = note.color,
									drawable = columns[note.key].column.note[1].drawable,
									x = columns[note.key].x,
									y = getY(note.startTime),
									sx = columns[note.key].column.note[note.type].sx,
									sy = columns[note.key].column.note[note.type].sy
								})
							end
						end
					elseif note.type == 2 then
						if note.state == 0 then
							if objectTime + offset <= currentTime + luaMania.config.hitTiming[#luaMania.config.hitTiming] and objectTime + offset > currentTime - luaMania.config.hitTiming[#luaMania.config.hitTiming - 1] and luaMania.map.objects.current[j] == nil then
								luaMania.map.objects.current[j] = note
								luaMania.map.objects.clean[objectTime][j] = nil
							else
								table.insert(luaMania.graphics.objects[3], {
									class = "drawable",
									drawable = columns[note.key].column.note[2].drawable,
									x = columns[note.key].x,
									y = getY(note.endTime),
									sx = columns[note.key].column.note[2].sx,
									sy = (getY(note.startTime) - getY(note.endTime)) / columns[note.key].column.note[2].drawable:getHeight()
								})
								table.insert(luaMania.graphics.objects[3], {
									class = "drawable",
									drawable = columns[note.key].column.note[1].drawable,
									x = columns[note.key].x,
									y = getY(note.startTime),
									sx = columns[note.key].column.note[1].sx,
									sy = columns[note.key].column.note[1].sy
								})
								table.insert(luaMania.graphics.objects[3], {
									class = "drawable",
									drawable = columns[note.key].column.note[1].drawable,
									x = columns[note.key].x,
									y = getY(note.endTime),
									sx = columns[note.key].column.note[1].sx,
									sy = columns[note.key].column.note[1].sy
								})
							end
						end
					end
				end
			end
		end
	end
	do
		if luaMania.map.objects.current ~= nil then
			for j = 1, keymode do
				local note = luaMania.map.objects.current[j]
				if note ~= nil then
					if note.type == 1 then
						if note.state == 0 then
							if luaMania.state.autoplay == 1 then
								if note.startTime + offset <= currentTime then
									if luaMania.map.hitSounds[j][1] ~= nil then
										self:playHitSound(self:getHitSound(luaMania.map.hitSounds[j][1]))
									end
									self:hit(-offset, j)
									note = nil
									table.remove(luaMania.map.hitSounds[j], 1)
								end
							end
							if note ~= nil then
								if note.startTime + offset < currentTime - luaMania.config.hitTiming[#luaMania.config.hitTiming - 1] then
									luaMania.state.stats.combo = 0
									luaMania.state.stats.hits[6] = luaMania.state.stats.hits[6] + 1
									if luaMania.map.objects.missed[note.startTime] == nil then
										luaMania.map.objects.missed[note.startTime] = {}
									end
									luaMania.map.objects.missed[note.startTime][j] = note
									luaMania.map.objects.missed[note.startTime][j].type[2] = 2
									note = nil
									table.remove(luaMania.map.hitSounds[j], 1)
								elseif luaMania.keyboard.keys.hitted[j] == 1 then
									if note.startTime + offset > currentTime + luaMania.config.hitTiming[#luaMania.config.hitTiming - 1] then
										luaMania.state.stats.combo = 0
										luaMania.state.stats.hits[6] = luaMania.state.stats.hits[6] + 1
										note.state = 2
									else
										note.state = 1
									end
									luaMania.keyboard.keys.hitted[j] = 0
								else
									table.insert(luaMania.graphics.objects[2], {type = "note", data = {
										{color = note.color, drawable = drawable.note, x = x, y = getY(note.startTime) - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y}
									}})
								end
							end
						end
						if note ~= nil then
							if note.state == 1 then
								note = nil
								table.remove(luaMania.map.hitSounds[j], 1)
							elseif note.state == 2 then
								if note.startTime + offset <= currentTime then
									if luaMania.map.objects.missed[note.startTime] == nil then
										luaMania.map.objects.missed[note.startTime] = {}
									end
									luaMania.map.objects.missed[note.startTime][j] = note
									luaMania.map.objects.missed[note.startTime][j].type[2] = 2
									note = nil
									table.remove(luaMania.map.hitSounds[j], 1)
								else
									table.insert(luaMania.graphics.objects[2], {type = "note", data = {
										{color = note.color, alpha = 128, drawable = drawable.note, x = x, y = getY(note.startTime) - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y}
									}})
								end
							end
						end
					elseif note.type == 2 then
						if note.state == 0 then
							if luaMania.state.autoplay == 1 then
								if note.startTime + offset <= currentTime then
									if luaMania.map.hitSounds[j][1] ~= nil then
										self:playHitSound(self:getHitSound(luaMania.map.hitSounds[j][1]))
									end
									self:hit(-offset, j)
								end
							end
							if note.endTime + offset < currentTime - luaMania.config.hitTiming[#luaMania.config.hitTiming - 1] then
								luaMania.state.stats.combo = 0
								luaMania.state.stats.hits[6] = luaMania.state.stats.hits[6] + 1
								if luaMania.map.objects.missed[note.startTime] == nil then
									luaMania.map.objects.missed[note.startTime] = {}
								end
								luaMania.map.objects.missed[note.startTime][j] = note
								luaMania.map.objects.missed[note.startTime][j].type[2] = 2
								note = nil
								table.remove(luaMania.map.hitSounds[j], 1)
							elseif luaMania.keyboard.keys.hitted[j] == 1 then
								if math.abs(note.startTime + offset - currentTime) <= luaMania.config.hitTiming[#luaMania.config.hitTiming - 1] then
									note.state = 1
								else
									luaMania.state.stats.combo = 0
									luaMania.state.stats.hits[6] = luaMania.state.stats.hits[6] + 1
									note.state = 2
								end
							else
								table.insert(luaMania.graphics.objects[2], {type = "note", data = {
									{color = note.color, drawable = drawable.slider, x = x, y = getY(note.endTime) - drawable.note:getHeight()*scale.y/2, sx = scale.x, sy = (getY(note.startTime) - getY(note.endTime))/drawable.slider:getHeight()},
									{color = note.color, drawable = drawable.note, x = x, y = getY(note.startTime) - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y},
									{color = note.color, drawable = drawable.note, x = x, y = getY(note.endTime) - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y}
								}})
							end
						end
						if note ~= nil then
							if note.state == 1 then
								if luaMania.keyboard.keys.hitted[j] == 0 and math.abs(note.endTime + offset - currentTime) > luaMania.config.hitTiming[#luaMania.config.hitTiming - 1] and luaMania.state.autoplay == 0 then
									luaMania.state.stats.combo = 0
									luaMania.state.stats.hits[6] = luaMania.state.stats.hits[6] + 1
									note.state = 2
								elseif luaMania.state.autoplay == 1 and note.endTime + offset <= currentTime then
									self:hit(-offset, j)
									note = nil
									table.remove(luaMania.map.hitSounds[j], 1)
									luaMania.keyboard.keys.hitted[j] = 0
								elseif luaMania.keyboard.keys.hitted[j] == 0 and math.abs(note.endTime + offset - currentTime) <= luaMania.config.hitTiming[#luaMania.config.hitTiming - 1] and luaMania.state.autoplay == 0 then
									self:hit(note.endTime - currentTime, j)
									note = nil
									table.remove(luaMania.map.hitSounds[j], 1)
									luaMania.keyboard.keys.hitted[j] = 0
								elseif luaMania.keyboard.keys.hitted[j] == 1 and note.endTime + offset - currentTime <= -1 * luaMania.config.hitTiming[#luaMania.config.hitTiming - 2] and luaMania.state.autoplay == 0 then
									self:hit(note.endTime - currentTime, j)
									note = nil
									table.remove(luaMania.map.hitSounds[j], 1)
									luaMania.keyboard.keys.hitted[j] = 0
								else
									if note.startTime + offset <= currentTime and note.endTime + offset > currentTime then
										note.startTime = currentTime - offset
										table.insert(luaMania.graphics.objects[2], {type = "note", data = {
											{color = note.color, drawable = drawable.slider, x = x, y = getY(note.endTime) - drawable.note:getHeight()*scale.y/2, sx = scale.x, sy = (getY(note.startTime) - getY(note.endTime))/drawable.slider:getHeight()},
											{color = note.color, drawable = drawable.note, x = x, y = love.graphics.getHeight() - hitPosition - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y},
											{color = note.color, drawable = drawable.note, x = x, y = getY(note.endTime) - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y}
										}})
									elseif note.startTime + offset > currentTime then
										table.insert(luaMania.graphics.objects[2], {type = "note", data = {
											{color = note.color, drawable = drawable.slider, x = x, y = getY(note.endTime) - drawable.note:getHeight()*scale.y/2, sx = scale.x, sy = (getY(note.startTime) - getY(note.endTime))/drawable.slider:getHeight()},
											{color = note.color, drawable = drawable.note, x = x, y = getY(note.startTime) - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y},
											{color = note.color, drawable = drawable.note, x = x, y = getY(note.endTime) - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y}
										}})
									end
								end
							end
						end
						if note ~= nil then
							if note.state == 2 then
								if data.keylocks[j] == 0 and math.abs(note.endTime + offset - currentTime) > luaMania.config.hitTiming[#luaMania.config.hitTiming - 1] then
									luaMania.state.stats.combo = 0
									luaMania.keyboard.keys.hitted[j] = 0
								end
								if note.endTime + offset <= currentTime - luaMania.config.hitTiming[#luaMania.config.hitTiming - 1] then
									if luaMania.keyboard.keys.hitted[j] == 1 then
										luaMania.state.stats.hits[5] = luaMania.state.stats.hits[5] + 1
									end
									if luaMania.map.objects.missed[note.startTime] == nil then
										luaMania.map.objects.missed[note.startTime] = {}
									end
									luaMania.map.objects.missed[note.startTime][j] = note
									luaMania.map.objects.missed[note.startTime][j].type[2] = 2
									note = nil
									table.remove(luaMania.map.hitSounds[j], 1)
									luaMania.keyboard.keys.hitted[j] = 0
								else
									table.insert(luaMania.graphics.objects[2], {type = "note", data = {
										{color = note.color, alpha = 128, drawable = drawable.slider, x = x, y = getY(note.endTime) - drawable.note:getHeight()*scale.y/2, sx = scale.x, sy = (getY(note.startTime) - getY(note.endTime))/drawable.slider:getHeight()},
										{color = note.color, alpha = 128, drawable = drawable.note, x = x, y = getY(note.startTime) - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y},
										{color = note.color, alpha = 128, drawable = drawable.note, x = x, y = getY(note.endTime) - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y}
									}})
								end
							end
						end
					end
				end
			end
		end
	end
	for notestartTime,notes in pairs(luaMania.map.objects.missed) do
		for j = 1, keymode do
			local note = notes[j]
			if note ~= nil then
				if note.type == 1 then
					if getY(note.startTime) > love.graphics.getHeight() then
						note = nil
					else
						table.insert(luaMania.graphics.objects[3], {
							class = "drawable",
							color = note.color,
							drawable = columns[note.key].column.note[1].drawable,
							x = columns[note.key].x,
							y = getY(note.startTime),
							sx = columns[note.key].column.note[note.type].sx,
							sy = columns[note.key].column.note[note.type].sy,
							alpha = 128
						})
					end
				elseif note.type == 2 then
					if getY(note.endTime) > love.graphics.getHeight() then
						note = nil
					else
						table.insert(luaMania.graphics.objects[3], {
							class = "drawable",
							drawable = columns[note.key].column.note[2].drawable,
							x = columns[note.key].x,
							y = getY(note.endTime),
							sx = columns[note.key].column.note[2].sx,
							sy = (getY(note.startTime) - getY(note.endTime)) / columns[note.key].column.note[2].drawable:getHeight(),
							alpha = 128
						})
						table.insert(luaMania.graphics.objects[3], {
							class = "drawable",
							drawable = columns[note.key].column.note[1].drawable,
							x = columns[note.key].x,
							y = getY(note.startTime),
							sx = columns[note.key].column.note[1].sx,
							sy = columns[note.key].column.note[1].sy,
							alpha = 128
						})
						table.insert(luaMania.graphics.objects[3], {
							class = "drawable",
							drawable = columns[note.key].column.note[1].drawable,
							x = columns[note.key].x,
							y = getY(note.endTime),
							sx = columns[note.key].column.note[1].sx,
							sy = columns[note.key].column.note[1].sy,
							alpha = 128
						})
					end
				end
			end
		end
		local remove = true
		for i,p in pairs(note) do
			remove = false
		end
		if remove then luaMania.map.objects.missed[notestartTime] = nil end
	end
	
	local coveerWidth = 0
	for key = 1, keymode do
		table.insert(luaMania.graphics.objects[2], {
			class = "rectangle",
			color = columns[key].column.background,
			x = columns[key].x,
			y = 0,
			w = columns[key].column.width,
			h = love.graphics.getHeight()
		})
	end
end

return getObjects