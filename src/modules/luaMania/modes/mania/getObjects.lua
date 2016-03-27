--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
local function getObjects()
	local beatmap = luaMania.state.map
	local currentTime = 0
	local skin = luaMania.ui.skin
	local offset = 0
	local hitPosition = 100
	
	local keymode = luaMania.map.info.keymode
	
	local columns = {}
	for i = 1, keymode do
		local column = skin.modes.mania.keymodes[keymode][key]
		local x = mania.columnStart
		for j = 1, i - 1 do
			x = x + column.width
		end
		columns[i] = {
			column = column,
			x = x
		}
	end
	
	function getY(time)
		return love.graphics.getHeight() - hitPosition
	end
	
	for index,point in pairs(luaMania.map.timing.all) do
		if point.startTime <= currentTime then
			if luaMania.map.timing.current ~= nil then
				if luaMania.map.timing.current.startTime <= currentTime and point.startTime <= currentTime and luaMania.map.timing.current.startTime < point.startTime then
					luaMania.map.timing.current = point
					data.stats.speed = point.velocity
				end
			else
				luaMania.map.timing.current = point
				data.stats.speed = point.velocity
			end
		end
	end
	
	local limit = math.ceil(currentTime + love.graphics.getHeight() / (data.config.speed * 0.1))
	for notestartTime = currentTime - data.od[#data.od - 1], limit do --HitObjects
		continue = false
		note = luaMania.map.objects.clean[notestartTime]
		if note ~= nil then
			for j = 1, keymode do
				if note[j] ~= nil then
					if getY(notestartTime) + drawable.note:getHeight()*scale.y < 0 then
						continue = true
						break
					end
					if note[j].type[1] == 1 then
						if note[j].type[2] == 0 then
							if notestartTime + offset <= currentTime + data.od[#data.od] and notestartTime + offset > currentTime - data.od[#data.od - 1] and luaMania.map.objects.current[j] == nil then
								luaMania.map.objects.current[j] = note[j]
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
							if notestartTime + offset <= currentTime + data.od[#data.od] and notestartTime + offset > currentTime - data.od[#data.od - 1] and luaMania.map.objects.current[j] == nil then
								luaMania.map.objects.current[j] = note[j]
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
	--[=[
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
	]=]
end

return getObjects