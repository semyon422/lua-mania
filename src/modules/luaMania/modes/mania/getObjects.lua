--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
local function getObjects()
	local beatmap = luaMania.map
	local currentTime = 0
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
		return love.graphics.getHeight() - hitPosition
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
	for objectTime = currentTime - luaMania.config.hitTiming[#luaMania.config.hitTiming - 1], limit do --HitObjects
		local continue = false
		if luaMania.map.objects.clean[objectTime] ~= nil then
			for j = 1, keymode do
				local note = luaMania.map.objects.clean[objectTime][j]
				if note ~= nil then
					if getY(objectTime) < 0 then
						continue = true
						break
					end
					if note.type == 1 then
						if note.state == 0 then
							if objectTime + offset <= currentTime + luaMania.config.hitTiming[#luaMania.config.hitTiming] and objectTime + offset > currentTime - luaMania.config.hitTiming[#luaMania.config.hitTiming - 1] and luaMania.map.objects.current[j] == nil then
								luaMania.map.objects.current[j] = note
								note = nil
							else
								table.insert(luaMania.graphics.objects[2], {
									class = "drawable",
									color = note.color,
									drawable = columns[note.key].column.note[note.type].drawable,
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
								note = nil
							else
								table.insert(luaMania.graphics.objects[2], {
									class = "drawable",
									color = note.color,
									drawable = columns[note.key].column.note[note.type].drawable,
									x = columns[note.key].x,
									y = getY(note.startTime),
									sx = columns[note.key].column.note[note.type].sx,
									sy = columns[note.key].column.note[note.type].sy
								})
								table.insert(luaMania.graphics.objects[2], {
									class = "drawable",
									color = note.color,
									drawable = columns[note.key].column.note[note.type].drawable,
									x = columns[note.key].x,
									y = getY(note.startTime),
									sx = columns[note.key].column.note[1].sx,
									sy = columns[note.key].column.note[1].sy
								})
								table.insert(luaMania.graphics.objects[2], {
									class = "drawable",
									color = note.color,
									drawable = columns[note.key].column.note[note.type].drawable,
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
		
		table.insert(luaMania.graphics.objects[1], {
			type = "rectangle",
			data = {
				preset = "maniaColumn",
				color = skin.config.Colours[ColumnColours[i]].Colour,
				x = globalscale * x + ColumnLineWidth[1],
				w = globalscale * ColumnWidth[i],
			}
		})
		table.insert(luaMania.graphics.objects[1], {
			type = "rectangle",
			data = {
				preset = "maniaColumn",
				color = skin.config.ColourColumnLine,
				x = globalscale * (x - ColumnLineWidth[1]) + ColumnLineWidth[1],
				w = globalscale * ColumnLineWidth[i]
			}
		})
	end
	table.insert(luaMania.graphics.objects[1], {
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