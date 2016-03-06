--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
local function getObjects(self)
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
	function update(key)
		drawable.note = skin.sprites.mania.note[ColumnColours[key]]
		drawable.slider = skin.sprites.mania.sustain[ColumnColours[key]]
		scale.x = globalscale * ColumnWidth[key] / drawable.note:getWidth()
		x = ColumnLineWidth[1] + skin.config.ColumnStart[keymode]
		for j = 1, key - 1 do
			x = x + ColumnWidth[j] + ColumnLineWidth[j + 1]
		end
		x = x * globalscale
	end
	function getY(time)
		local distance = 0
		for index,point in pairs(data.beatmap.timing.all) do
			if point.type == 1 then
				if time > currentTime then
					if point.time < time and point.endtime > currentTime then
						if point.time <= currentTime and point.endtime > currentTime then
							if time > point.time and time <= point.endtime then
								distance = distance + (time - currentTime) * point.value
							else
								distance = distance + (point.endtime - currentTime) * point.value
							end
						elseif point.time > currentTime and point.endtime <= time then
							distance = distance + (point.endtime - point.time) * point.value
						elseif point.time < time and point.endtime > time then
							distance = distance + (time - point.time) * point.value
						elseif point.endtime <= currentTime then
						
						else
							print("e1")
							print("i: " .. index .. " p.t:" .. point.time .. " p.et:" .. point.endtime .. " p.v:" .. point.value .. " d:" .. distance .. " t: " .. time .. " cT: " .. currentTime)
						end
					end
				elseif time < currentTime then
					if point.endtime > time and point.time < currentTime then
						if point.time <= currentTime and point.endtime > currentTime then
							if time > point.time and time <= point.endtime then
								distance = distance + (time - currentTime) * point.value
							else
								distance = distance + (point.time - currentTime) * point.value
							end
						elseif point.endtime < currentTime and point.time >= time then
							distance = distance + (point.time - point.endtime) * point.value
						elseif point.time < time and point.endtime > time then
							distance = distance + (time - point.endtime) * point.value
						elseif point.endtime <= currentTime then
						
						else
							print("e2")
							print("i: " .. index .. " p.t:" .. point.time .. " p.et:" .. point.endtime .. " p.v:" .. point.value .. " d:" .. distance .. " t: " .. time .. " cT: " .. currentTime)
						end
					end
				end
			elseif point.type == 0 then
				if time > currentTime then
					if point.time < time and point.endtime > currentTime then
						if point.time <= currentTime and point.endtime > currentTime then
							if time > point.time and time <= point.endtime then
								distance = distance + (time - currentTime)
							else
								distance = distance + (point.endtime - currentTime)
							end
						elseif point.time > currentTime and point.endtime <= time then
							distance = distance + (point.endtime - point.time)
						elseif point.time < time and point.endtime > time then
							distance = distance + (time - point.time)
						elseif point.endtime <= currentTime then
						
						else
							print("e3")
							print("i: " .. index .. " p.t:" .. point.time .. " p.et:" .. point.endtime .. " p.v:" .. point.value .. " d:" .. distance .. " t: " .. time .. " cT: " .. currentTime)
						end
					end
				elseif time < currentTime then
					if point.endtime > time and point.time < currentTime then
						if point.time <= currentTime and point.endtime > currentTime then
							if time > point.time and time <= point.endtime then
								distance = distance + (time - currentTime)
							else
								distance = distance + (point.time - currentTime)
							end
						elseif point.endtime < currentTime and point.time >= time then
							distance = distance + (point.time - point.endtime)
						elseif point.time < time and point.endtime > time then
							distance = distance + (time - point.endtime)
						elseif point.endtime <= currentTime then
						
						else
							print("e4")
							print("i: " .. index .. " p.t:" .. point.time .. " p.et:" .. point.endtime .. " p.v:" .. point.value .. " d:" .. distance .. " t: " .. time .. " cT: " .. currentTime)
						end
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
		if point.time <= currentTime then
			if point.type == 0 then
				if data.beatmap.timing.global ~= nil then
					if data.beatmap.timing.global.time <= currentTime and point.time <= currentTime and data.beatmap.timing.global.time < point.time then
						data.beatmap.timing.global = point
						data.stats.speed = 1
					end
				else
					data.beatmap.timing.global = point
					data.stats.speed = 1
				end
			elseif point.type == 1 then
				if data.beatmap.timing.current ~= nil then
					if data.beatmap.timing.current.time <= currentTime and point.time <= currentTime and data.beatmap.timing.current.time < point.time then
						data.beatmap.timing.current = point
						data.stats.speed = point.value
					end
				else
					data.beatmap.timing.current = point
					data.stats.speed = point.value
				end
			end
		end
	end
	
	local limit = math.ceil(currentTime + data.height / (data.config.speed * 0.1))
	for notetime = currentTime - data.od[#data.od - 1], limit do --HitObjects
		continue = false
		note = data.beatmap.objects.clean[notetime]
		if note ~= nil then
			for j = 1, keymode do
				if note[j] ~= nil then
					if getY(notetime) + drawable.note:getHeight()*scale.y < 0 then
						continue = true
						break
					end
					if note[j][1][1] == 1 then
						if note[j][1][2] == 0 then
							if notetime + offset <= currentTime + data.od[#data.od] and notetime + offset > currentTime - data.od[#data.od - 1] and data.beatmap.objects.current[j] == nil then
								data.beatmap.objects.current[j] = note[j]
								note[j] = nil
							else
								update(j)
								table.insert(data.objects[2], {type = "note", data = {
									{drawable = drawable.note, x = x, y = getY(note[j][2]) - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y}
								}})
							end
						end
					elseif note[j][1][1] == 2 then
						if note[j][1][2] == 0 then
							if notetime + offset <= currentTime + data.od[#data.od] and notetime + offset > currentTime - data.od[#data.od - 1] and data.beatmap.objects.current[j] == nil then
								data.beatmap.objects.current[j] = note[j]
								note[j] = nil
							else
								update(j)
								table.insert(data.objects[2], {type = "note", data = {
									{drawable = drawable.slider, x = x, y = getY(note[j][3]) - drawable.note:getHeight()*scale.y/2, sx = scale.x, sy = (getY(note[j][2]) - getY(note[j][3]))/drawable.slider:getHeight()},
									{drawable = drawable.note, x = x, y = getY(note[j][2]) - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y},
									{drawable = drawable.note, x = x, y = getY(note[j][3]) - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y}
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
					if note[j][1][1] == 1 then
						if note[j][1][2] == 0 then
							if data.autoplay == 1 then
								if note[j][2] + offset <= currentTime then
									if data.beatmap.hitSounds[j][1] ~= nil then
										self:playHitSound(self:getHitSound(data.beatmap.hitSounds[j][1]))
									end
									self:hit(-offset, j)
									note[j] = nil
									table.remove(data.beatmap.hitSounds[j], 1)
								end
							end
							if note[j] ~= nil then
								if note[j][2] + offset < currentTime - data.od[#data.od - 1] then
									data.stats.combo = 0
									data.stats.hits[6] = data.stats.hits[6] + 1
									if data.beatmap.objects.missed[note[j][2]] == nil then
										data.beatmap.objects.missed[note[j][2]] = {}
									end
									data.beatmap.objects.missed[note[j][2]][j] = note[j]
									data.beatmap.objects.missed[note[j][2]][j][1][2] = 2
									note[j] = nil
									table.remove(data.beatmap.hitSounds[j], 1)
								elseif data.keyhits[j] == 1 then
									if note[j][2] + offset > currentTime + data.od[#data.od - 1] then
										data.stats.combo = 0
										data.stats.hits[6] = data.stats.hits[6] + 1
										note[j][1][2] = 2
									else
										note[j][1][2] = 1
									end
									data.keyhits[j] = 0
								else
									update(j)
									table.insert(data.objects[2], {type = "note", data = {
										{drawable = drawable.note, x = x, y = getY(note[j][2]) - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y}
									}})
								end
							end
						end
						if note[j] ~= nil then
							if note[j][1][2] == 1 then
								note[j] = nil
								table.remove(data.beatmap.hitSounds[j], 1)
							elseif note[j][1][2] == 2 then
								if note[j][2] + offset <= currentTime then
									if data.beatmap.objects.missed[note[j][2]] == nil then
										data.beatmap.objects.missed[note[j][2]] = {}
									end
									data.beatmap.objects.missed[note[j][2]][j] = note[j]
									data.beatmap.objects.missed[note[j][2]][j][1][2] = 2
									note[j] = nil
									table.remove(data.beatmap.hitSounds[j], 1)
								else
									update(j)
									table.insert(data.objects[2], {type = "note", data = {
										{color = {255,255,255,128}, drawable = drawable.note, x = x, y = getY(note[j][2]) - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y}
									}})
								end
							end
						end
					elseif note[j][1][1] == 2 then
						if note[j][1][2] == 0 then
							if data.autoplay == 1 then
								if note[j][2] + offset <= currentTime then
									if data.beatmap.hitSounds[j][1] ~= nil then
										self:playHitSound(self:getHitSound(data.beatmap.hitSounds[j][1]))
									end
									self:hit(-offset, j)
								end
							end
							if note[j][3] + offset < currentTime - data.od[#data.od - 1] then
								data.stats.combo = 0
								data.stats.hits[6] = data.stats.hits[6] + 1
								if data.beatmap.objects.missed[note[j][2]] == nil then
									data.beatmap.objects.missed[note[j][2]] = {}
								end
								data.beatmap.objects.missed[note[j][2]][j] = note[j]
								data.beatmap.objects.missed[note[j][2]][j][1][2] = 2
								note[j] = nil
								table.remove(data.beatmap.hitSounds[j], 1)
							elseif data.keyhits[j] == 1 then
								if math.abs(note[j][2] + offset - currentTime) <= data.od[#data.od - 1] then
									note[j][1][2] = 1
								else
									data.stats.combo = 0
									data.stats.hits[6] = data.stats.hits[6] + 1
									note[j][1][2] = 2
								end
							else
								update(j)
								table.insert(data.objects[2], {type = "note", data = {
									{drawable = drawable.slider, x = x, y = getY(note[j][3]) - drawable.note:getHeight()*scale.y/2, sx = scale.x, sy = (getY(note[j][2]) - getY(note[j][3]))/drawable.slider:getHeight()},
									{drawable = drawable.note, x = x, y = getY(note[j][2]) - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y},
									{drawable = drawable.note, x = x, y = getY(note[j][3]) - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y}
								}})
							end
						end
						if note[j] ~= nil then
							if note[j][1][2] == 1 then
								if data.keyhits[j] == 0 and math.abs(note[j][3] + offset - currentTime) > data.od[#data.od - 1] and data.autoplay == 0 then
									data.stats.combo = 0
									data.stats.hits[6] = data.stats.hits[6] + 1
									note[j][1][2] = 2
								elseif data.autoplay == 1 and note[j][3] + offset <= currentTime then
									self:hit(-offset, j)
									note[j] = nil
									table.remove(data.beatmap.hitSounds[j], 1)
									data.keyhits[j] = 0
								elseif data.keyhits[j] == 0 and math.abs(note[j][3] + offset - currentTime) <= data.od[#data.od - 1] and data.autoplay == 0 then
									self:hit(note[j][3] - currentTime, j)
									note[j] = nil
									table.remove(data.beatmap.hitSounds[j], 1)
									data.keyhits[j] = 0
								elseif data.keyhits[j] == 1 and note[j][3] + offset - currentTime <= -1 * data.od[#data.od - 2] and data.autoplay == 0 then
									self:hit(note[j][3] - currentTime, j)
									note[j] = nil
									table.remove(data.beatmap.hitSounds[j], 1)
									data.keyhits[j] = 0
								else
									update(j)
									if note[j][2] + offset <= currentTime and note[j][3] + offset > currentTime then
										note[j][2] = currentTime - offset
										table.insert(data.objects[2], {type = "note", data = {
											{drawable = drawable.slider, x = x, y = getY(note[j][3]) - drawable.note:getHeight()*scale.y/2, sx = scale.x, sy = (getY(note[j][2]) - getY(note[j][3]))/drawable.slider:getHeight()},
											{drawable = drawable.note, x = x, y = data.height - hitPosition - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y},
											{drawable = drawable.note, x = x, y = getY(note[j][3]) - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y}
										}})
									elseif note[j][2] + offset > currentTime then
										table.insert(data.objects[2], {type = "note", data = {
											{drawable = drawable.slider, x = x, y = getY(note[j][3]) - drawable.note:getHeight()*scale.y/2, sx = scale.x, sy = (getY(note[j][2]) - getY(note[j][3]))/drawable.slider:getHeight()},
											{drawable = drawable.note, x = x, y = getY(note[j][2]) - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y},
											{drawable = drawable.note, x = x, y = getY(note[j][3]) - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y}
										}})
									end
								end
							end
						end
						if note[j] ~= nil then
							if note[j][1][2] == 2 then
								if data.keylocks[j] == 0 and math.abs(note[j][3] + offset - currentTime) > data.od[#data.od - 1] then
									data.stats.combo = 0
									data.keyhits[j] = 0
								end
								if note[j][3] + offset <= currentTime - data.od[#data.od - 1] then
									if data.keyhits[j] == 1 then
										data.stats.hits[5] = data.stats.hits[5] + 1
									end
									if data.beatmap.objects.missed[note[j][2]] == nil then
										data.beatmap.objects.missed[note[j][2]] = {}
									end
									data.beatmap.objects.missed[note[j][2]][j] = note[j]
									data.beatmap.objects.missed[note[j][2]][j][1][2] = 2
									note[j] = nil
									table.remove(data.beatmap.hitSounds[j], 1)
									data.keyhits[j] = 0
								else
									update(j)
									table.insert(data.objects[2], {type = "note", data = {
										{color = {255, 255, 255, 128}, drawable = drawable.slider, x = x, y = getY(note[j][3]) - drawable.note:getHeight()*scale.y/2, sx = scale.x, sy = (getY(note[j][2]) - getY(note[j][3]))/drawable.slider:getHeight()},
										{color = {255, 255, 255, 128}, drawable = drawable.note, x = x, y = getY(note[j][2]) - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y},
										{color = {255, 255, 255, 128}, drawable = drawable.note, x = x, y = getY(note[j][3]) - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y}
									}})
								end
							end
						end
					end
				end
			end
		end
	end
	for notetime,note in pairs(data.beatmap.objects.missed) do
		if note ~= nil then
			for j = 1, keymode do
				if note[j] ~= nil then
					if note[j][1][1] == 1 then
						if getY(note[j][2]) > data.height then
							note[j] = nil
						else
							update(j)
							table.insert(data.objects[2], {type = "note", data = {
								{color = {255, 255, 255, 128}, drawable = drawable.note, x = x, y = getY(note[j][2]) - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y}
							}})
						end
					elseif note[j][1][1] == 2 then
						if getY(note[j][3]) > data.height then
							note[j] = nil
						else
							update(j)
							table.insert(data.objects[2], {type = "note", data = {
								{color = {255, 255, 255, 128}, drawable = drawable.slider, x = x, y = getY(note[j][3]) - drawable.note:getHeight()*scale.y/2, sx = scale.x, sy = (getY(note[j][2]) - getY(note[j][3]))/drawable.slider:getHeight()},
								{color = {255, 255, 255, 128}, drawable = drawable.note, x = x, y = getY(note[j][2]) - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y},
								{color = {255, 255, 255, 128}, drawable = drawable.note, x = x, y = getY(note[j][3]) - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y}
							}})
						end
					end
				end
			end
			local remove = true
			for i,p in pairs(note) do
				remove = false
			end
			if remove then data.beatmap.objects.missed[notetime] = nil end
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