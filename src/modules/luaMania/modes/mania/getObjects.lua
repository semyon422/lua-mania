--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
local function getObjects()
	local beatmap = luaMania.map
	local currentTime = luaMania.map.stats.currentTime
	local skin = luaMania.ui.skin
	local offset = luaMania.config.offset
	local hitPosition = luaMania.config.hitPosition
	local noteLayer = luaMania.config.noteLayer
	
	local oClean = luaMania.map.objects.clean
	local oCurrent = luaMania.map.objects.current
	local oMissed = luaMania.map.objects.missed
	
	local tAll = luaMania.map.timing.all
	
	local hitTiming = luaMania.config.hitTiming
	
	local kHitted = luaMania.keyboard.keys.hitted
	local kPressed = luaMania.keyboard.keys.pressed
	
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
		local distance = 0
		for timingPointIndex = 1, #tAll do
			local timingPoint = tAll[timingPointIndex]
			if time > currentTime then
				if timingPoint.startTime < time and timingPoint.endTime > currentTime then
					if timingPoint.startTime <= currentTime and timingPoint.endTime > currentTime then
						if time > timingPoint.startTime and time <= timingPoint.endTime then
							distance = distance + (time - currentTime) * timingPoint.velocity
						else
							distance = distance + (timingPoint.endTime - currentTime) * timingPoint.velocity
						end
					elseif timingPoint.startTime > currentTime and timingPoint.endTime <= time then
						distance = distance + (timingPoint.endTime - timingPoint.startTime) * timingPoint.velocity
					elseif timingPoint.startTime < time and timingPoint.endTime > time then
						distance = distance + (time - timingPoint.startTime) * timingPoint.velocity
					elseif timingPoint.endTime <= currentTime then
					
					else
						print("e1")
						print("i: " .. index .. " p.t:" .. timingPoint.startTime .. " p.et:" .. timingPoint.endTime .. " p.v:" .. timingPoint.velocity .. " d:" .. distance .. " t: " .. time .. " cT: " .. currentTime)
					end
				end
			elseif time < currentTime then
				if timingPoint.endTime > time and timingPoint.startTime < currentTime then
					if timingPoint.startTime <= currentTime and timingPoint.endTime > currentTime then
						if time > timingPoint.startTime and time <= timingPoint.endTime then
							distance = distance + (time - currentTime) * timingPoint.velocity
						else
							distance = distance + (timingPoint.startTime - currentTime) * timingPoint.velocity
						end
					elseif timingPoint.endTime < currentTime and timingPoint.startTime >= time then
						distance = distance + (timingPoint.startTime - timingPoint.endTime) * timingPoint.velocity
					elseif timingPoint.startTime < time and timingPoint.endTime > time then
						distance = distance + (time - timingPoint.endTime) * timingPoint.velocity
					elseif timingPoint.endTime <= currentTime then
					
					else
						print("e2")
						print("i: " .. index .. " p.t:" .. timingPoint.startTime .. " p.et:" .. timingPoint.endTime .. " p.v:" .. timingPoint.velocity .. " d:" .. distance .. " t: " .. time .. " cT: " .. currentTime)
					end
				end
			end
		end
		if currentTime >= 0 then
			return love.graphics.getHeight() - hitPosition - offset * luaMania.config.speed - distance * luaMania.config.speed
		else
			return love.graphics.getHeight() - hitPosition - offset * luaMania.config.speed - distance * luaMania.config.speed + currentTime * luaMania.config.speed
		end
	end
	
	for objectTime = currentTime - hitTiming[#hitTiming - 1], math.huge do
		if getY(objectTime) < 0 then
			break
		end
		if oClean[objectTime] ~= nil then
			for j = 1, keymode do
				local note = oClean[objectTime][j]
				if note ~= nil then
				----------------------------------------------------------------
					if note.type == 1 then
						if objectTime + offset <= currentTime + hitTiming[#hitTiming] and oCurrent[j] == nil then
							oCurrent[j] = note
							oClean[objectTime][j] = nil
						else
							local preset = columns[note.key].column.note
							table.insert(luaMania.graphics.objects[noteLayer], {
								class = "drawable", drawable = preset[1].drawable,
								x = columns[note.key].x, y = getY(note.startTime) - preset[1].drawable:getHeight() * preset[1].sy,
								sx = preset[1].sx, sy = preset[1].sy
							})
						end
					elseif note.type == 2 then
						if objectTime + offset <= currentTime + hitTiming[#hitTiming] and oCurrent[j] == nil then
							oCurrent[j] = note
							oClean[objectTime][j] = nil
						else
							local preset = columns[note.key].column.note
							table.insert(luaMania.graphics.objects[noteLayer], {
								class = "drawable", drawable = preset[2].drawable,
								x = columns[note.key].x, y = getY(note.endTime) - preset[1].drawable:getHeight() * preset[1].sy / 2,
								sx = preset[2].sx, sy = (getY(note.startTime) - getY(note.endTime)) / preset[2].drawable:getHeight()
							})
							table.insert(luaMania.graphics.objects[noteLayer], {
								class = "drawable", drawable = preset[1].drawable,
								x = columns[note.key].x, y = getY(note.startTime) - preset[1].drawable:getHeight() * preset[1].sy,
								sx = preset[1].sx, sy = preset[1].sy
							})
							table.insert(luaMania.graphics.objects[noteLayer], {
								class = "drawable", drawable = preset[1].drawable,
								x = columns[note.key].x, y = getY(note.endTime) - preset[1].drawable:getHeight() * preset[1].sy,
								sx = preset[1].sx, sy = preset[1].sy
							})
						end
					end
				----------------------------------------------------------------
				end
			end
		end
	end
	--oCurrent
	for j = 1, keymode do
		local note = oCurrent[j]
		----------------------------------------------------------------
		if note ~= nil and note.state == 0 then
			if note.type == 1 then
				if note.startTime + offset < currentTime - hitTiming[#hitTiming - 1] then
					-- combo = 0, miss++, remove hitSound
					oMissed[note.startTime] = oMissed[note.startTime] or {}
					oMissed[note.startTime][j] = note
					oCurrent[j] = nil
				elseif kHitted[j] then
					kHitted[j] = nil
					if note.startTime + offset > currentTime + hitTiming[#hitTiming - 1] then
						-- combo = 0, miss++
						note.state = 2
					else
						-- remove hitSound
						oCurrent[j] = nil
					end
				else
					local preset = columns[note.key].column.note
					table.insert(luaMania.graphics.objects[noteLayer], {
						class = "drawable", drawable = preset[1].drawable,
						x = columns[note.key].x, y = getY(note.startTime) - preset[1].drawable:getHeight() * preset[1].sy,
						sx = preset[1].sx, sy = preset[1].sy
					})
				end
			elseif note.type == 2 then
				if note.endTime + offset < currentTime - hitTiming[#hitTiming - 1] then
					-- combo = 0, miss++, remove hitSound
					luaMania.map.objects.missed[note.startTime] = luaMania.map.objects.missed[note.startTime] or {}
					luaMania.map.objects.missed[note.startTime][j] = note
					oCurrent[j] = nil
				elseif kHitted[j] then
					if math.abs(note.startTime + offset - currentTime) <= hitTiming[#hitTiming - 1] then
						note.state = 1
					else
						-- combo = 0, miss++
						note.state = 2
					end
				else
					local preset = columns[note.key].column.note
					table.insert(luaMania.graphics.objects[noteLayer], {
						class = "drawable", drawable = preset[2].drawable,
						x = columns[note.key].x, y = getY(note.endTime) - preset[1].drawable:getHeight() * preset[1].sy / 2,
						sx = preset[2].sx, sy = (getY(note.startTime) - getY(note.endTime)) / preset[2].drawable:getHeight()
					})
					table.insert(luaMania.graphics.objects[noteLayer], {
						class = "drawable", drawable = preset[1].drawable,
						x = columns[note.key].x, y = getY(note.startTime) - preset[1].drawable:getHeight() * preset[1].sy,
						sx = preset[1].sx, sy = preset[1].sy
					})
					table.insert(luaMania.graphics.objects[noteLayer], {
						class = "drawable", drawable = preset[1].drawable,
						x = columns[note.key].x, y = getY(note.endTime) - preset[1].drawable:getHeight() * preset[1].sy,
						sx = preset[1].sx, sy = preset[1].sy
					})
				end
			end
		end
		----------------------------------------------------------------
		if note ~= nil and note.state == 1 then
			if note.type == 2 then
				if not kHitted[j] and math.abs(note.endTime + offset - currentTime) > hitTiming[#hitTiming - 1] then
					-- combo = 0,  miss++
					note.state = 2
				elseif not kHitted[j] and math.abs(note.endTime + offset - currentTime) <= hitTiming[#hitTiming - 1] then
					--miss++, remove hitSound
					oCurrent[j] = nil
				elseif kHitted[j] and note.endTime + offset - currentTime <= -1 * hitTiming[#hitTiming - 2] then
					kHitted[j] = nil
					--hit(note.endTime - currentTime, j), remove hitSound
					oCurrent[j] = nil
				else
					if note.startTime + offset <= currentTime and note.endTime + offset > currentTime then
						note.startTime = currentTime - offset
						local preset = columns[note.key].column.note
						table.insert(luaMania.graphics.objects[noteLayer], {
							class = "drawable", drawable = preset[2].drawable,
							x = columns[note.key].x, y = getY(note.endTime) - preset[1].drawable:getHeight() * preset[1].sy / 2,
							sx = preset[2].sx, sy = (getY(note.startTime) - getY(note.endTime)) / preset[2].drawable:getHeight()
						})
						table.insert(luaMania.graphics.objects[noteLayer], {
							class = "drawable", drawable = preset[1].drawable,
							x = columns[note.key].x, y = love.graphics.getHeight() - hitPosition - preset[1].drawable:getHeight() * preset[1].sy,
							sx = preset[1].sx, sy = preset[1].sy
						})
						table.insert(luaMania.graphics.objects[noteLayer], {
							class = "drawable", drawable = preset[1].drawable,
							x = columns[note.key].x, y = getY(note.endTime) - preset[1].drawable:getHeight() * preset[1].sy,
							sx = preset[1].sx, sy = preset[1].sy
						})
					elseif note.startTime + offset > currentTime then
						local preset = columns[note.key].column.note
						table.insert(luaMania.graphics.objects[noteLayer], {
							class = "drawable", drawable = preset[2].drawable,
							x = columns[note.key].x, y = getY(note.endTime) - preset[1].drawable:getHeight() * preset[1].sy / 2,
							sx = preset[2].sx, sy = (getY(note.startTime) - getY(note.endTime)) / preset[2].drawable:getHeight()
						})
						table.insert(luaMania.graphics.objects[noteLayer], {
							class = "drawable", drawable = preset[1].drawable,
							x = columns[note.key].x, y = getY(note.startTime) - preset[1].drawable:getHeight() * preset[1].sy,
							sx = preset[1].sx, sy = preset[1].sy
						})
						table.insert(luaMania.graphics.objects[noteLayer], {
							class = "drawable", drawable = preset[1].drawable,
							x = columns[note.key].x, y = getY(note.endTime) - preset[1].drawable:getHeight() * preset[1].sy,
							sx = preset[1].sx, sy = preset[1].sy
						})
					end
				end
			end
		end
		----------------------------------------------------------------
		if note ~= nil and note.state == 2 then
			if note.type == 1 then
				if note.startTime + offset <= currentTime then
					luaMania.map.objects.missed[note.startTime] = luaMania.map.objects.missed[note.startTime] or {}
					luaMania.map.objects.missed[note.startTime][j] = note
					oCurrent[j] = nil
					--remove hitSound
				else
					local preset = columns[note.key].column.note
					table.insert(luaMania.graphics.objects[noteLayer], {
						class = "drawable", drawable = preset[1].drawable, alpha = 128,
						x = columns[note.key].x, y = getY(note.startTime) - preset[1].drawable:getHeight() * preset[1].sy,
						sx = preset[1].sx, sy = preset[1].sy
					})
				end
			elseif note.type == 2 then
				if not kPressed[j] and math.abs(note.endTime + offset - currentTime) > hitTiming[#hitTiming - 1] then
					--combo = 0
					kHitted[j] = nil
				end
				if note.endTime + offset <= currentTime - hitTiming[#hitTiming - 1] then
					if kHitted[j] then
						--50++
					end
					luaMania.map.objects.missed[note.startTime] = luaMania.map.objects.missed[note.startTime] or {}
					luaMania.map.objects.missed[note.startTime][j] = note
					oCurrent[j] = nil
					--remove hitSound
					kHitted[j] = nil
				else
					local preset = columns[note.key].column.note
					table.insert(luaMania.graphics.objects[noteLayer], {
						class = "drawable", drawable = preset[2].drawable, alpha = 128,
						x = columns[note.key].x, y = getY(note.endTime) - preset[1].drawable:getHeight() * preset[1].sy / 2,
						sx = preset[2].sx, sy = (getY(note.startTime) - getY(note.endTime)) / preset[2].drawable:getHeight()
					})
					table.insert(luaMania.graphics.objects[noteLayer], {
						class = "drawable", drawable = preset[1].drawable, alpha = 128,
						x = columns[note.key].x, y = getY(note.startTime) - preset[1].drawable:getHeight() * preset[1].sy,
						sx = preset[1].sx, sy = preset[1].sy
					})
					table.insert(luaMania.graphics.objects[noteLayer], {
						class = "drawable", drawable = preset[1].drawable, alpha = 128,
						x = columns[note.key].x, y = getY(note.endTime) - preset[1].drawable:getHeight() * preset[1].sy,
						sx = preset[1].sx, sy = preset[1].sy
					})
				end
			end
		end
		----------------------------------------------------------------
	end
			
	for objectTime,notes in pairs(oMissed) do
		for j = 1, keymode do
			local note = notes[j]
			if note ~= nil then
				if note.type == 1 then
					if getY(note.startTime) > love.graphics.getHeight() then
						oMissed[objectTime][j] = nil
					else
						local preset = columns[note.key].column.note
						table.insert(luaMania.graphics.objects[noteLayer], {
							class = "drawable", drawable = preset[1].drawable, alpha = 128,
							x = columns[note.key].x, y = getY(note.startTime) - preset[1].drawable:getHeight() * preset[1].sy,
							sx = preset[1].sx, sy = preset[1].sy
						})
					end
				elseif note.type == 2 then
					if getY(note.endTime) > love.graphics.getHeight() then
						oMissed[objectTime][j] = nil
					else
						local preset = columns[note.key].column.note
						table.insert(luaMania.graphics.objects[noteLayer], {
							class = "drawable", drawable = preset[2].drawable, alpha = 128,
							x = columns[note.key].x, y = getY(note.endTime) - preset[1].drawable:getHeight() * preset[1].sy,
							sx = preset[2].sx, sy = (getY(note.startTime) - getY(note.endTime)) / preset[2].drawable:getHeight()
						})
						table.insert(luaMania.graphics.objects[noteLayer], {
							class = "drawable", drawable = preset[1].drawable, alpha = 128,
							x = columns[note.key].x, y = getY(note.startTime) - preset[1].drawable:getHeight() * preset[1].sy,
							sx = preset[1].sx, sy = preset[1].sy
						})
						table.insert(luaMania.graphics.objects[noteLayer], {
							class = "drawable", drawable = preset[1].drawable, alpha = 128,
							x = columns[note.key].x, y = getY(note.endTime) - preset[1].drawable:getHeight() * preset[1].sy,
							sx = preset[1].sx, sy = preset[1].sy
						})
					end
				end
			end
		end
		local remove = true
		for i,p in pairs(notes) do
			remove = false
		end
		if remove then oMissed[objectTime] = nil end
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
	
	table.insert(luaMania.graphics.objects[3], {
		class = "rectangle",
		color = {255,255,255},
		x = columns[1].x,
		y = love.graphics.getHeight() - luaMania.config.hitPosition,
		w = 4 * columns[1].column.width,
		h = 5
	})
end

return getObjects