--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
local function getObjects()
	local beatmap = data.beatmap
	local currentTime = data.stats.currentTime
	local skin = data.skin
	local offset = data.config.offset
	local hitPosition = data.config.hitPosition
	local globalscale = data.config.globalscale
	
	local keymode = data.beatmap.info.keymode
	
	local ColumnColours = skin.config.ManiaColours[keymode]
	local ColumnWidth = skin.config.ColumnWidth[keymode]
	local ColumnLineWidth = skin.config.ColumnLineWidth[keymode]
	
	if data.stats.speed == nil then
		data.stats.speed = data.config.speed
	end
	local speed = data.stats.speed
	
	
	local drawable = {}
	local scale = {}
	function update(key, note)
		drawable.note = skin.sprites.mania.note[ColumnColours[key]]
		drawable.slider = skin.sprites.mania.sustain[ColumnColours[key]]
		scale.x = globalscale * ColumnWidth[key] / drawable.note:getWidth()
		x = ColumnLineWidth[1] + skin.config.ColumnStart[keymode]
		for j = 1, key - 1 do
			x = x + ColumnWidth[j] + ColumnLineWidth[j + 1]
		end
		x = x * globalscale
		if note ~= nil then
			if note.colorScheme ~= nil then
				drawable.note = skin.sprites.colorScheme[note.colorScheme].NoteImage
				drawable.slider = skin.sprites.colorScheme[note.colorScheme].NoteImageL
			end
		end
	end
	function getY(time)
		local distance = 0
		for index,point in pairs(data.beatmap.timing.all) do
			if time > currentTime then
				if point.startTime < time and point.endTime > currentTime then
					if point.startTime <= currentTime and point.endTime > currentTime then
						if time > point.startTime and time <= point.endTime then
							distance = distance + (time - currentTime) * point.velocity
						else
							distance = distance + (point.endTime - currentTime) * point.velocity
						end
					elseif point.startTime > currentTime and point.endTime <= time then
						distance = distance + (point.endTime - point.startTime) * point.velocity
					elseif point.startTime < time and point.endTime > time then
						distance = distance + (time - point.startTime) * point.velocity
					elseif point.endTime <= currentTime then
					
					else
						print("e1")
						print("i: " .. index .. " p.t:" .. point.startTime .. " p.et:" .. point.endTime .. " p.v:" .. point.velocity .. " d:" .. distance .. " t: " .. time .. " cT: " .. currentTime)
					end
				end
			elseif time < currentTime then
				if point.endTime > time and point.startTime < currentTime then
					if point.startTime <= currentTime and point.endTime > currentTime then
						if time > point.startTime and time <= point.endTime then
							distance = distance + (time - currentTime) * point.velocity
						else
							distance = distance + (point.startTime - currentTime) * point.velocity
						end
					elseif point.endTime < currentTime and point.startTime >= time then
						distance = distance + (point.startTime - point.endTime) * point.velocity
					elseif point.startTime < time and point.endTime > time then
						distance = distance + (time - point.endTime) * point.velocity
					elseif point.endTime <= currentTime then
					
					else
						print("e2")
						print("i: " .. index .. " p.t:" .. point.startTime .. " p.et:" .. point.endTime .. " p.v:" .. point.velocity .. " d:" .. distance .. " t: " .. time .. " cT: " .. currentTime)
					end
				end
			end
		end
		if currentTime >= 0 then
			return data.height - hitPosition - offset*data.config.speed - distance*data.config.speed
		else
			return data.height - hitPosition - offset*data.config.speed - distance*data.config.speed + currentTime*data.config.speed
		end
	end
	
	update(1)
	scale.y = globalscale * ColumnWidth[1] / drawable.note:getWidth()
	
	data.drawedNotes = 0
	
	for index,point in pairs(data.beatmap.timing.all) do
		if point.startTime <= currentTime then
			if data.beatmap.timing.current ~= nil then
				if data.beatmap.timing.current.startTime <= currentTime and point.startTime <= currentTime and data.beatmap.timing.current.startTime < point.startTime then
					data.beatmap.timing.current = point
					data.stats.speed = point.velocity
				end
			else
				data.beatmap.timing.current = point
				data.stats.speed = point.velocity
			end
		end
	end
	
	local limit = math.ceil(currentTime + data.height / (data.config.speed * 0.1))
	for notestartTime = currentTime - data.od[#data.od - 1], limit do --HitObjects
		continue = false
		note = data.beatmap.objects.clean[notestartTime]
		if note ~= nil then
			for j = 1, keymode do
				if note[j] ~= nil then
					if getY(notestartTime) + drawable.note:getHeight()*scale.y < 0 then
						continue = true
						break
					end
					if note[j].type[1] == 1 then
						if note[j].type[2] == 0 then
							if notestartTime + offset <= currentTime + data.od[#data.od] and notestartTime + offset > currentTime - data.od[#data.od - 1] and data.beatmap.objects.current[j] == nil then
								data.beatmap.objects.current[j] = note[j]
								note[j] = nil
							else
								update(j, note[j])
								table.insert(data.objects[2], {type = "note", data = {
									{color = note[j].color, drawable = drawable.note, x = x, y = getY(note[j].startTime) - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y}
								}})
							end
						end
					elseif note[j].type[1] == 2 then
						if note[j].type[2] == 0 then
							if notestartTime + offset <= currentTime + data.od[#data.od] and notestartTime + offset > currentTime - data.od[#data.od - 1] and data.beatmap.objects.current[j] == nil then
								data.beatmap.objects.current[j] = note[j]
								note[j] = nil
							else
								update(j, note[j])
								table.insert(data.objects[2], {type = "note", data = {
									{color = note[j].color, drawable = drawable.slider, x = x, y = getY(note[j].endTime) - drawable.note:getHeight()*scale.y/2, sx = scale.x, sy = (getY(note[j].startTime) - getY(note[j].endTime))/drawable.slider:getHeight()},
									{color = note[j].color, drawable = drawable.note, x = x, y = getY(note[j].startTime) - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y},
									{color = note[j].color, drawable = drawable.note, x = x, y = getY(note[j].endTime) - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y}
								}})
							end
						end
					end
				end
			end
		end
		if continue then break end
	end
	do
		note = data.beatmap.objects.current
		if note ~= nil then
			for j = 1, keymode do
				if note[j] ~= nil then
					if note[j].type[1] == 1 then
						if note[j].type[2] == 0 then
							if data.autoplay == 1 then
								if note[j].startTime + offset <= currentTime then
									if data.beatmap.hitSounds[j][1] ~= nil then
										self:playHitSound(self:getHitSound(data.beatmap.hitSounds[j][1]))
									end
									self:hit(-offset, j)
									note[j] = nil
									table.remove(data.beatmap.hitSounds[j], 1)
								end
							end
							if note[j] ~= nil then
								if note[j].startTime + offset < currentTime - data.od[#data.od - 1] then
									data.stats.combo = 0
									data.stats.hits[6] = data.stats.hits[6] + 1
									if data.beatmap.objects.missed[note[j].startTime] == nil then
										data.beatmap.objects.missed[note[j].startTime] = {}
									end
									data.beatmap.objects.missed[note[j].startTime][j] = note[j]
									data.beatmap.objects.missed[note[j].startTime][j].type[2] = 2
									note[j] = nil
									table.remove(data.beatmap.hitSounds[j], 1)
								elseif data.keyhits[j] == 1 then
									if note[j].startTime + offset > currentTime + data.od[#data.od - 1] then
										data.stats.combo = 0
										data.stats.hits[6] = data.stats.hits[6] + 1
										note[j].type[2] = 2
									else
										note[j].type[2] = 1
									end
									data.keyhits[j] = 0
								else
									update(j, note[j])
									table.insert(data.objects[2], {type = "note", data = {
										{color = note[j].color, drawable = drawable.note, x = x, y = getY(note[j].startTime) - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y}
									}})
								end
							end
						end
						if note[j] ~= nil then
							if note[j].type[2] == 1 then
								note[j] = nil
								table.remove(data.beatmap.hitSounds[j], 1)
							elseif note[j].type[2] == 2 then
								if note[j].startTime + offset <= currentTime then
									if data.beatmap.objects.missed[note[j].startTime] == nil then
										data.beatmap.objects.missed[note[j].startTime] = {}
									end
									data.beatmap.objects.missed[note[j].startTime][j] = note[j]
									data.beatmap.objects.missed[note[j].startTime][j].type[2] = 2
									note[j] = nil
									table.remove(data.beatmap.hitSounds[j], 1)
								else
									update(j, note[j])
									table.insert(data.objects[2], {type = "note", data = {
										{color = note[j].color, alpha = 128, drawable = drawable.note, x = x, y = getY(note[j].startTime) - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y}
									}})
								end
							end
						end
					elseif note[j].type[1] == 2 then
						if note[j].type[2] == 0 then
							if data.autoplay == 1 then
								if note[j].startTime + offset <= currentTime then
									if data.beatmap.hitSounds[j][1] ~= nil then
										self:playHitSound(self:getHitSound(data.beatmap.hitSounds[j][1]))
									end
									self:hit(-offset, j)
								end
							end
							if note[j].endTime + offset < currentTime - data.od[#data.od - 1] then
								data.stats.combo = 0
								data.stats.hits[6] = data.stats.hits[6] + 1
								if data.beatmap.objects.missed[note[j].startTime] == nil then
									data.beatmap.objects.missed[note[j].startTime] = {}
								end
								data.beatmap.objects.missed[note[j].startTime][j] = note[j]
								data.beatmap.objects.missed[note[j].startTime][j].type[2] = 2
								note[j] = nil
								table.remove(data.beatmap.hitSounds[j], 1)
							elseif data.keyhits[j] == 1 then
								if math.abs(note[j].startTime + offset - currentTime) <= data.od[#data.od - 1] then
									note[j].type[2] = 1
								else
									data.stats.combo = 0
									data.stats.hits[6] = data.stats.hits[6] + 1
									note[j].type[2] = 2
								end
							else
								update(j, note[j])
								table.insert(data.objects[2], {type = "note", data = {
									{color = note[j].color, drawable = drawable.slider, x = x, y = getY(note[j].endTime) - drawable.note:getHeight()*scale.y/2, sx = scale.x, sy = (getY(note[j].startTime) - getY(note[j].endTime))/drawable.slider:getHeight()},
									{color = note[j].color, drawable = drawable.note, x = x, y = getY(note[j].startTime) - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y},
									{color = note[j].color, drawable = drawable.note, x = x, y = getY(note[j].endTime) - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y}
								}})
							end
						end
						if note[j] ~= nil then
							if note[j].type[2] == 1 then
								if data.keyhits[j] == 0 and math.abs(note[j].endTime + offset - currentTime) > data.od[#data.od - 1] and data.autoplay == 0 then
									data.stats.combo = 0
									data.stats.hits[6] = data.stats.hits[6] + 1
									note[j].type[2] = 2
								elseif data.autoplay == 1 and note[j].endTime + offset <= currentTime then
									self:hit(-offset, j)
									note[j] = nil
									table.remove(data.beatmap.hitSounds[j], 1)
									data.keyhits[j] = 0
								elseif data.keyhits[j] == 0 and math.abs(note[j].endTime + offset - currentTime) <= data.od[#data.od - 1] and data.autoplay == 0 then
									self:hit(note[j].endTime - currentTime, j)
									note[j] = nil
									table.remove(data.beatmap.hitSounds[j], 1)
									data.keyhits[j] = 0
								elseif data.keyhits[j] == 1 and note[j].endTime + offset - currentTime <= -1 * data.od[#data.od - 2] and data.autoplay == 0 then
									self:hit(note[j].endTime - currentTime, j)
									note[j] = nil
									table.remove(data.beatmap.hitSounds[j], 1)
									data.keyhits[j] = 0
								else
									update(j, note[j])
									if note[j].startTime + offset <= currentTime and note[j].endTime + offset > currentTime then
										note[j].startTime = currentTime - offset
										table.insert(data.objects[2], {type = "note", data = {
											{color = note[j].color, drawable = drawable.slider, x = x, y = getY(note[j].endTime) - drawable.note:getHeight()*scale.y/2, sx = scale.x, sy = (getY(note[j].startTime) - getY(note[j].endTime))/drawable.slider:getHeight()},
											{color = note[j].color, drawable = drawable.note, x = x, y = data.height - hitPosition - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y},
											{color = note[j].color, drawable = drawable.note, x = x, y = getY(note[j].endTime) - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y}
										}})
									elseif note[j].startTime + offset > currentTime then
										table.insert(data.objects[2], {type = "note", data = {
											{color = note[j].color, drawable = drawable.slider, x = x, y = getY(note[j].endTime) - drawable.note:getHeight()*scale.y/2, sx = scale.x, sy = (getY(note[j].startTime) - getY(note[j].endTime))/drawable.slider:getHeight()},
											{color = note[j].color, drawable = drawable.note, x = x, y = getY(note[j].startTime) - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y},
											{color = note[j].color, drawable = drawable.note, x = x, y = getY(note[j].endTime) - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y}
										}})
									end
								end
							end
						end
						if note[j] ~= nil then
							if note[j].type[2] == 2 then
								if data.keylocks[j] == 0 and math.abs(note[j].endTime + offset - currentTime) > data.od[#data.od - 1] then
									data.stats.combo = 0
									data.keyhits[j] = 0
								end
								if note[j].endTime + offset <= currentTime - data.od[#data.od - 1] then
									if data.keyhits[j] == 1 then
										data.stats.hits[5] = data.stats.hits[5] + 1
									end
									if data.beatmap.objects.missed[note[j].startTime] == nil then
										data.beatmap.objects.missed[note[j].startTime] = {}
									end
									data.beatmap.objects.missed[note[j].startTime][j] = note[j]
									data.beatmap.objects.missed[note[j].startTime][j].type[2] = 2
									note[j] = nil
									table.remove(data.beatmap.hitSounds[j], 1)
									data.keyhits[j] = 0
								else
									update(j, note[j])
									table.insert(data.objects[2], {type = "note", data = {
										{color = note[j].color, alpha = 128, drawable = drawable.slider, x = x, y = getY(note[j].endTime) - drawable.note:getHeight()*scale.y/2, sx = scale.x, sy = (getY(note[j].startTime) - getY(note[j].endTime))/drawable.slider:getHeight()},
										{color = note[j].color, alpha = 128, drawable = drawable.note, x = x, y = getY(note[j].startTime) - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y},
										{color = note[j].color, alpha = 128, drawable = drawable.note, x = x, y = getY(note[j].endTime) - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y}
									}})
								end
							end
						end
					end
				end
			end
		end
	end
	for notestartTime,note in pairs(data.beatmap.objects.missed) do
		if note ~= nil then
			for j = 1, keymode do
				if note[j] ~= nil then
					if note[j].type[1] == 1 then
						if getY(note[j].startTime) > data.height then
							note[j] = nil
						else
							update(j, note[j])
							table.insert(data.objects[2], {type = "note", data = {
								{color = note[j].color, alpha = 128, drawable = drawable.note, x = x, y = getY(note[j].startTime) - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y}
							}})
						end
					elseif note[j].type[1] == 2 then
						if getY(note[j].endTime) > data.height then
							note[j] = nil
						else
							update(j, note[j])
							table.insert(data.objects[2], {type = "note", data = {
								{color = note[j].color, alpha = 128, drawable = drawable.slider, x = x, y = getY(note[j].endTime) - drawable.note:getHeight()*scale.y/2, sx = scale.x, sy = (getY(note[j].startTime) - getY(note[j].endTime))/drawable.slider:getHeight()},
								{color = note[j].color, alpha = 128, drawable = drawable.note, x = x, y = getY(note[j].startTime) - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y},
								{color = note[j].color, alpha = 128, drawable = drawable.note, x = x, y = getY(note[j].endTime) - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y}
							}})
						end
					end
				end
			end
			local remove = true
			for i,p in pairs(note) do
				remove = false
			end
			if remove then data.beatmap.objects.missed[notestartTime] = nil end
		end
	end
	
	local coveerWidth = ColumnLineWidth[1]
	for i = 1, keymode do
		local x = ColumnLineWidth[1] + skin.config.ColumnStart[keymode]
		for j = 1, i - 1 do
			x = x + ColumnWidth[j] + ColumnLineWidth[j + 1]
		end
		coveerWidth = coveerWidth + ColumnWidth[i] + ColumnLineWidth[i + 1]
		
		table.insert(data.objects[1], {
			type = "rectangle",
			data = {
				preset = "maniaColumn",
				color = skin.config.Colours[ColumnColours[i]].Colour,
				x = globalscale * x + ColumnLineWidth[1],
				w = globalscale * ColumnWidth[i],
			}
		})
		table.insert(data.objects[1], {
			type = "rectangle",
			data = {
				preset = "maniaColumn",
				color = skin.config.ColourColumnLine,
				x = globalscale * (x - ColumnLineWidth[1]) + ColumnLineWidth[1],
				w = globalscale * ColumnLineWidth[i]
			}
		})
	end
	table.insert(data.objects[1], {
		type = "rectangle",
		data = {
			preset = "maniaColumn",
			color = skin.config.ColourColumnLine,
			x = globalscale * (coveerWidth - ColumnLineWidth[1]) + ColumnLineWidth[1] + skin.config.ColumnStart[keymode],
			w = globalscale * ColumnLineWidth[#ColumnLineWidth]
		}
	})
	
	lg.setColor(255, 255, 255, 255)
end

return getObjects