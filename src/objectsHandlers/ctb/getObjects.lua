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
	function update(sign)
		drawable.note = skin.sprites.mania.note[ColumnColours[1]]
		drawable.slider = skin.sprites.mania.sustain[ColumnColours[1]]
		scale.x = globalscale * ColumnWidth[1] / drawable.note:getWidth()
		x = ColumnLineWidth[1] + skin.config.ColumnStart[2]
		if sign == -1 then
			x = x + ColumnWidth[1] + ColumnLineWidth[1 + 1]
		end
		x = x * globalscale
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
	for notestartTime = currentTime, limit do --HitObjects
		continue = false
		note = data.beatmap.objects.clean[notestartTime]
		if note ~= nil then
			if note ~= nil then
				if getY(notestartTime) + drawable.note:getHeight()*scale.y < 0 then
					continue = true
					break
				end
					--if notestartTime + offset <= currentTime + data.od[#data.od] and notestartTime + offset > currentTime - data.od[#data.od - 1] and data.beatmap.objects.current[j] == nil then
					--	data.beatmap.objects.current[j] = note
					--	note = nil
					--else
						local color = {255, 255 ,255, 255/((note.startTime - currentTime)/data.height)}
						update((data.stats.x - note.startX) / math.abs(data.stats.x - note.startX))
						table.insert(data.objects[2], {type = "note", data = {
							{color = color, drawable = drawable.slider, x = x, y = data.height - math.abs(data.stats.x - note.startX) - drawable.note:getHeight()*scale.y, sx = scale.x, sy = (math.abs(data.stats.x - note.startX))/drawable.slider:getHeight()},
							{color = color, drawable = drawable.note, x = x, y = data.height - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y},
							{color = color, drawable = drawable.note, x = x, y = data.height - math.abs(data.stats.x - note.startX) - drawable.note:getHeight()*scale.y, sx = scale.x, sy = scale.y}
						}})
						table.insert(data.objects[3], {
							type = "circle",
							data = {
								x = note.startX,
								y = getY(note.startTime)
							}
						})
					--end
			end
		end
		if continue then break end
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