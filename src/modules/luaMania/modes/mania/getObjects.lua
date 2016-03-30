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
		local continue = false
		if luaMania.map.objects.clean[objectTime] ~= nil then
			for j = 1, keymode do
				local note = luaMania.map.objects.clean[objectTime][j]
				if note ~= nil then
					if note.type == 1 then
						if note.state == 0 then
							if objectTime + offset <= currentTime + luaMania.config.hitTiming[#luaMania.config.hitTiming] and objectTime + offset > currentTime - luaMania.config.hitTiming[#luaMania.config.hitTiming - 1] and luaMania.map.objects.current[j] == nil then
								luaMania.map.objects.current[j] = note
								note = nil
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
								note = nil
							else
								table.insert(luaMania.graphics.objects[3], {
									class = "drawable",
									color = note.color,
									drawable = columns[note.key].column.note[2].drawable,
									x = columns[note.key].x,
									y = getY(note.startTime),
									sx = columns[note.key].column.note[2].sx,
									sy = columns[note.key].column.note[2].sy
								})
								table.insert(luaMania.graphics.objects[3], {
									class = "drawable",
									color = note.color,
									drawable = columns[note.key].column.note[1].drawable,
									x = columns[note.key].x,
									y = getY(note.startTime),
									sx = columns[note.key].column.note[1].sx,
									sy = columns[note.key].column.note[1].sy
								})
								table.insert(luaMania.graphics.objects[3], {
									class = "drawable",
									color = note.color,
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