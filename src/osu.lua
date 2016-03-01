--[[
lua-mania
Copyright (C) 2016 Semyon Jolnirov (semyon422)

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.
--]]
osuClass = {}
osuClass.__index = osuClass

function osuClass.new(init)
	local self = setmetatable({}, osuClass)
	data = init
	return self
end

function osuClass.drawHUD(self)
	local hud = data.hud
	local dt = data.dt
	
	lg.setFont(data.ui.songlist.font)
		
	lg.setColor(255, 255, 255, 255)
	if data.ui.debug == false then
		lg.print(
			"FPS: "..love.timer.getFPS().."\n"..
			"time: " .. data.stats.currentTime .. "\n" ..
			"speed: " .. data.config.speed .. "\n" ..
			"realSpeed: " .. data.stats.speed .. "\n" ..
			"offset: " .. data.config.offset .. "\n" ..
			"autoplay: " .. data.autoplay .. "\n" ..
			"pitch: " .. data.config.pitch .. "\n" ..
			"HitObjects: " .. data.beatmap.objects.count .. "\n" ..
			"miss: " .. data.stats.hits[6] .. "\n" ..
			"50: " .. data.stats.hits[5] .. "\n" ..
			"100: " .. data.stats.hits[4] .. "\n" ..
			"200: " .. data.stats.hits[3] .. "\n" ..
			"300: " .. data.stats.hits[2] .. "\n" ..
			"MAX: " .. data.stats.hits[1] .. "\n" ..
			"MaxCombo: " .. data.stats.maxcombo .. "\n" ..
			"Combo: " .. data.stats.combo .. "\n"
		, 0, 0, 0, 1, 1)
	else
		lg.print(
			"FPS: "..love.timer.getFPS().."\n"..
			"scroll: " .. data.stats.currentTime .. "\n" ..
			"speed: " .. data.stats.speed .. "\n" ..
			"notes: " .. data.drawedNotes .. "\n"
		, 0, 0, 0,1,1)
	end
	lg.setColor(255, 255, 255, 255)
end

function osuClass.beat(self, state)
	if state == 1 then
		data.beatradius = 0.85
	elseif state == 0 then
		if data.beatradius < 1 then data.beatradius = data.beatradius + 0.002 end
	end
	
end

function osuClass.start(self)
	if data.beatmap.audio ~= nil then
		data.beatmap.audio:stop()
		data.beatmap.audio:play()
		data.beatmap.audio:pause()
		data.beatmap.audio:setPitch(data.config.pitch)
	end
	data.stats.currentTime = -data.config.preview
	data.starttime = love.timer.getTime() * 1000 - data.stats.currentTime
	data.play = -1
	data.state = "started"
	--beatmap.audio:play()
	--beatmap.audio:setVolume(0)
end
function osuClass.stop(self)
	if data.beatmap.audio ~= nil then
		data.beatmap.audio:stop()
	end
	data.play = 0
	data.stats.currentTime = 0
	data.state = "stopped"
end
function osuClass.play(self)
	if data.play == 1 then
		data.play = 1
		data.state = "started"
		if data.beatmap.audio ~= nil then
			data.beatmap.audio:setPitch(data.config.pitch)
			data.beatmap.audio:play()
		end
	elseif data.play == 2 and data.stats.currentTime < 0 then
		data.play = -1
	elseif data.play == 2 then
		data.play = 1
		if data.beatmap.audio ~= nil then
			--beatmap.audio:seek(data.beatmap.audio:tell() - 1)
			data.beatmap.audio:setPitch(data.config.pitch)
			data.beatmap.audio:play()
		end
	else
		self:start()
	end
end
function osuClass.pause(self)
	data.play = 2
	data.state = "paused"
	if data.beatmap.audio ~= nil then
		data.beatmap.audio:pause()
	end
end

function osuClass.hit(self, ms, key)
	local trueMs = ms + data.config.offset
	local beatmap = data.beatmap
	local currentTime = data.stats.currentTime
	local offset = data.config.offset
	if data.beatmap.objects.current[key][1][1] == 2 and data.beatmap.objects.current[key][1][2] == 2 and data.beatmap.objects.current[key][2] + offset <= currentTime + data.od[#data.od] and data.beatmap.objects.current[key][2] + offset > currentTime - data.od[#data.od - 1] then
	
	else
		for i = 1, #data.od do
			if math.abs(trueMs) <= data.od[i] then 
				data.stats.lastHit = i
				data.stats.hits[i] = data.stats.hits[i] + 1
				if i == #data.od then data.stats.combo = 0 end
				break
			end
		end
	end
	if math.abs(trueMs) <= data.od[#data.od] then 
		if data.stats.averageMismatch.count >= data.stats.averageMismatch.maxCount then
			data.stats.averageMismatch.value =  math.floor((data.stats.averageMismatch.value * (data.stats.averageMismatch.count - 1) + ms) / (data.stats.averageMismatch.count))
		else
			data.stats.averageMismatch.value = math.floor((data.stats.averageMismatch.value * data.stats.averageMismatch.count + ms) / (data.stats.averageMismatch.count + 1))
			data.stats.averageMismatch.count = data.stats.averageMismatch.count + 1
		end
		
		--data.config.offset = -1 * data.stats.averageMismatch.value
		table.insert(data.stats.mismatch, trueMs)
		
		data.stats.combo = data.stats.combo + 1
		if data.stats.maxcombo < data.stats.combo then
			data.stats.maxcombo = data.stats.combo
		end
		data.keyhits[key] = 1
	end
	if data.beatmap.objects.current[key][1][1] == 2 then
		if data.beatmap.objects.current[key][2] < data.stats.currentTime - data.od[#data.od - 1] and data.beatmap.objects.current[key][3] > data.stats.currentTime + data.od[#data.od - 1] then
			data.keyhits[key] = 1
		end
	end
end

function osuClass.playHitsound(self, source)
	local hitSound = love.audio.newSource(source[1])
	local volume = 1
	hitSound:setPitch(data.config.pitch)
	if source[2] ~= nil then
		volume = source[2]
	elseif data.beatmap.timing.current ~= nil then
		volume = data.beatmap.timing.current.volume
	elseif data.beatmap.timing.global ~= nil then
		volume = data.beatmap.timing.global.volume
	end
	hitSound:setVolume(volume)
	--print(volume)
	hitSound:play()
end

function osuClass.keyboard(self)
	local dt = data.dt
	local hud = data.hud
	local beatmap = data.beatmap

	local keyboard = data.keyboard

	for act,key in pairs(keyboard.key) do
		if key[2] ~= nil then
			if love.keyboard.isDown(key[1]) and love.keyboard.isDown(key[2]) then
					key.action()
			end
		elseif key[2] == nil then
			if love.keyboard.isDown(key[1]) then
				if data.keylocks[key[1]] == nil then
					key.action()
				end
				data.keylocks[key[1]] = 1
			else
				data.keylocks[key[1]] = nil
			end
		end
	end
	if data.beatmap.info ~= nil then
		for keynumber,key in pairs(keyboard.maniaLayouts[data.beatmap.info.keymode]) do
			if love.keyboard.isDown(key) then
				if data.keylocks[keynumber] == 0 then
					if data.beatmap.hitSounds[keynumber] ~= nil then
						if data.beatmap.hitSounds[keynumber][1] ~= nil then
							self:playHitsound(self:getHitSound(data.beatmap.hitSounds[keynumber][1]))
						end
					end
					if data.beatmap.objects.current[keynumber] ~= nil then
						self:hit(data.beatmap.objects.current[keynumber][2] - data.stats.currentTime, keynumber)
					end
				end
				data.keylocks[keynumber] = 1
			else
				data.keylocks[keynumber] = 0
				data.keyhits[keynumber] = 0
			end
		end
	end
	
	if data.beatmap.audio ~= nil then
		if data.play == -1 then
			data.stats.currentTime = math.floor(love.timer.getTime() * 1000 - data.starttime)
			if data.stats.currentTime >= 0 then
				data.play = 1
				data.beatmap.audio:play()
			end
		elseif data.play == 1 then
			data.stats.currentTime =  math.floor(data.beatmap.audio:tell() * 1000)
		elseif data.play == 2 then
			--data.stats.currentTime = math.floor(data.beatmap.audio:tell() * 1000)
			data.starttime = math.floor(love.timer.getTime() * 1000 - data.stats.currentTime)
		end
	else
		if data.play == -1 then
			data.stats.currentTime = math.floor(love.timer.getTime() * 1000 - data.starttime)
			if data.stats.currentTime >= 0 then
				data.play = 1
			end
		elseif data.play == 1 then
			data.stats.currentTime = math.floor(love.timer.getTime() * 1000 - data.starttime)
		elseif data.play == 2 then
			data.starttime = math.floor(love.timer.getTime() * 1000 - data.stats.currentTime)
		end
	end

end

osuClass.removeExtension = require "src.removeExtension"

function osuClass.getHitSound(self, hitSound)
	pathHitSound = nil
	for i,format in pairs(data.audioFormats) do
		if love.filesystem.exists(data.beatmap.path .. "/" .. hitSound[1] .. "." .. format) then
			pathHitSound = data.beatmap.path .. "/" .. hitSound[1] .. "." .. format
			return {pathHitSound, hitSound[2]}
		end
	end
	
	for i,format in pairs(data.audioFormats) do
		if love.filesystem.exists(data.config.skinname .. "/" .. hitSound[1] .. "." .. format) then
			pathHitSound = data.config.skinname .. "/" .. hitSound[1] .. "." .. format
			return {pathHitSound, hitSound[2]}
		end
	end
	
	if filename == "blank" then
		return {"res/blank.ogg", 0}
	end
	if filename == "" then
		return {"res/blank.ogg", 0}
	end
end

function osuClass.drawBackground(self)
	local background = data.skin.sprites.background
	local backgroundDarkness = data.config.backgroundDarkness
	local skin = data.skin
	
	if skin.config.background.draw then
		scale = 1
		if data.width < background:getWidth() * scale then
			-- nothing
		end
		if data.height < background:getHeight() * scale then
			scale = data.height / background:getHeight()
		end
		if data.width > background:getWidth() * scale then
			scale = data.width / background:getWidth()
		end
		if data.height > background:getHeight() * scale then
			scale = data.height / background:getHeight()
		end

		lg.draw(background, data.width / 2, data.height / 2, 0, scale, scale, background:getWidth() / 2, background:getHeight() / 2)
		
		lg.setColor(0, 0, 0, (backgroundDarkness / 100) * 255)
		lg.rectangle("fill", 0, 0, data.width, data.height)
		lg.setColor(255, 255, 255, 255)
	end

	
end

function osuClass.drawNotes(self)
	local beatmap = data.beatmap
	local currentTime = data.stats.currentTime
	local skin = data.skin
	local offset = data.config.offset
	local hitPosition = data.config.hitPosition
	local globalscale = data.config.globalscale
	
	if data.stats.speed == nil then
		data.stats.speed = data.config.speed
	end
	local speed = data.stats.speed
	
	keymode = data.beatmap.info.keymode
	
	ColumnColours = skin.config.ManiaColours[keymode]
	ColumnWidth = skin.config.ColumnWidth[keymode]
	ColumnLineWidth = skin.config.ColumnLineWidth[keymode]
	drawable = {}
	scale = {}
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
						elseif point.endtime < currentTime then
						
						else
							print("e")
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
						elseif point.endtime < currentTime then
						
						else
							print("e")
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
						elseif point.endtime < currentTime then
						
						else
							print("e")
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
						elseif point.endtime < currentTime then
						
						else
							print("e")
							print("i: " .. index .. " p.t:" .. point.time .. " p.et:" .. point.endtime .. " p.v:" .. point.value .. " d:" .. distance .. " t: " .. time .. " cT: " .. currentTime)
						end
					end
				end
			end
		end
		return data.height - hitPosition - offset*data.config.speed - distance*data.config.speed
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
						print("newGlobal")
					end
				else
					data.beatmap.timing.global = point
					data.stats.speed = 1
					print("newGlobal")
				end
				--table.remove(data.beatmap.timing.all, 1)
			elseif point.type == 1 then
				if data.beatmap.timing.current ~= nil then
					if data.beatmap.timing.current.time <= currentTime and point.time <= currentTime and data.beatmap.timing.current.time < point.time then
						data.beatmap.timing.current = point
						data.stats.speed = point.value
						print("newCurrent")
						print(point.time)
					end
				else
					data.beatmap.timing.current = point
					data.stats.speed = point.value
					print("newCurrentNew")
				end
				--table.remove(data.beatmap.timing.all, 1)
			end
		end
	end
	
	for notetime = currentTime - data.od[#data.od - 1], math.ceil(currentTime + data.height / data.config.speed) do --HitObjects
		note = data.beatmap.objects.clean[notetime]
		if note ~= nil then
			for j = 1, keymode do
				if note[j] ~= nil then
					if note[j][1][1] == 1 then
						if note[j][1][2] == 0 then
							if notetime + offset <= currentTime + data.od[#data.od] and notetime + offset > currentTime - data.od[#data.od - 1] and data.beatmap.objects.current[j] == nil then
								data.beatmap.objects.current[j] = note[j]
								note[j] = nil
							else
								update(j)
								lg.draw(drawable.note, x, getY(notetime) - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
							end
						end
					elseif note[j][1][1] == 2 then
						if note[j][1][2] == 0 then
							if notetime + offset <= currentTime + data.od[#data.od] and notetime + offset > currentTime - data.od[#data.od - 1] and data.beatmap.objects.current[j] == nil then
								data.beatmap.objects.current[j] = note[j]
								note[j] = nil
							else
								update(j)
								local lnscale = -(getY(note[j][3]) - getY(note[j][2]))/drawable.slider:getHeight()
								lg.draw(drawable.slider, x, getY(note[j][3]), 0, scale.x, lnscale)
								lg.draw(drawable.note, x, getY(notetime) - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
								lg.draw(drawable.note, x, getY(note[j][3]) - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
							end
						end
					end
				end
			end
		end
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
										self:playHitsound(self:getHitSound(data.beatmap.hitSounds[j][1]))
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
									lg.draw(drawable.note, x, getY(note[j][2]) - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
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
									lg.setColor(255,255,255,128)
									lg.draw(drawable.note, x, getY(note[j][2]) - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
									lg.setColor(255,255,255,255)
								end
							end
						end
					elseif note[j][1][1] == 2 then
						if note[j][1][2] == 0 then
							if data.autoplay == 1 then
								if note[j][2] + offset <= currentTime then
									if data.beatmap.hitSounds[j][1] ~= nil then
										self:playHitsound(self:getHitSound(data.beatmap.hitSounds[j][1]))
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
								local lnscale = -(getY(note[j][3]) - getY(note[j][2]))/drawable.slider:getHeight()
								lg.draw(drawable.slider, x, getY(note[j][3]), 0, scale.x, lnscale)
								lg.draw(drawable.note, x, getY(note[j][2]) - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
								lg.draw(drawable.note, x, getY(note[j][3]) - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
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
										local lnscale = -(getY(note[j][3]) - getY(currentTime))/drawable.slider:getHeight() -- + offset
										lg.draw(drawable.slider, x, getY(note[j][3]), 0, scale.x, lnscale)
										lg.draw(drawable.note, x, data.height - hitPosition - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
										lg.draw(drawable.note, x, getY(note[j][3]) - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
										note[j][2] = currentTime - offset
									elseif note[j][2] + offset <= currentTime and note[j][3] + offset <= currentTime then
									elseif note[j][2] + offset > currentTime then
										local lnscale = -(getY(note[j][3]) - getY(note[j][2]))/drawable.slider:getHeight()
										lg.draw(drawable.slider, x, getY(note[j][3]), 0, scale.x, lnscale)
										lg.draw(drawable.note, x, getY(note[j][2]) - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
										lg.draw(drawable.note, x, getY(note[j][3]) - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
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
									local lnscale = -(getY(note[j][3]) - getY(note[j][2]))/drawable.slider:getHeight()
									lg.setColor(255,255,255,128)
									lg.draw(drawable.slider, x, getY(note[j][3]), 0, scale.x, lnscale)
									lg.draw(drawable.note, x, getY(note[j][2]) - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
									lg.draw(drawable.note, x, getY(note[j][3]) - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
									lg.setColor(255,255,255,255)
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
						if getY(note[j][2]) < math.ceil(currentTime - (hitPosition + drawable.note:getHeight() * scale.y) / data.config.speed) then
							note[j] = nil
						else
							update(j)
							lg.setColor(255,255,255,128)
							lg.draw(drawable.note, x, getY(notetime) - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
							lg.setColor(255,255,255,255)
						end
					elseif note[j][1][1] == 2 then
						if note[j][3] < math.ceil(currentTime - (hitPosition + drawable.note:getHeight() * scale.y) / data.config.speed) then
							note[j] = nil
						else
							update(j)
							lg.setColor(255,255,255,128)
							local lnscale = -(getY(note[j][3]) - getY((note[j][2])))/drawable.slider:getHeight()
							lg.draw(drawable.slider, x, getY(note[j][3]), 0, scale.x, lnscale)
							if note[j][2] > currentTime - math.ceil(hitPosition/data.config.speed) - math.ceil(drawable.note:getHeight()*scale.y/data.config.speed) then
								lg.draw(drawable.note, x, getY(note[j][2]) - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
							end
							lg.draw(drawable.note, x, getY(note[j][3]) - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
							lg.setColor(255,255,255,255)
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
end

function osuClass.drawUI(self)
	data.beatmap = data.beatmap
	skin = data.skin
	offset = data.config.offset
	globalscale = data.config.globalscale
	
	keymode = data.beatmap.info.keymode
	
	ColumnColours = skin.config.ManiaColours[keymode]
	ColumnWidth = skin.config.ColumnWidth[keymode]
	ColumnLineWidth = skin.config.ColumnLineWidth[keymode]
	
	coveerWidth = ColumnLineWidth[1]
	for i = 1, keymode do
		local x = ColumnLineWidth[1] + skin.config.ColumnStart[keymode]
		for j = 1, i - 1 do
			x = x + ColumnWidth[j] + ColumnLineWidth[j + 1]
		end
		coveerWidth = coveerWidth + ColumnWidth[i] + ColumnLineWidth[i + 1]
		colourBG = skin.config.Colours[ColumnColours[i]].Colour
		lg.setColor(colourBG[1],
								colourBG[2],
								colourBG[3],
								colourBG[4])
		lg.rectangle("fill", globalscale * x + ColumnLineWidth[1], 0, globalscale * ColumnWidth[i], data.height)
		colourLine = skin.config.ColourColumnLine
		lg.setColor(colourLine[1],
								colourLine[2],
								colourLine[3],
								colourLine[4])
		lg.rectangle("fill", globalscale * (x - ColumnLineWidth[1]) + ColumnLineWidth[1], 0, globalscale * ColumnLineWidth[i], data.height)
	end
	lg.rectangle("fill", globalscale * (coveerWidth - ColumnLineWidth[1]) + ColumnLineWidth[1] + skin.config.ColumnStart[keymode], 0, globalscale * ColumnLineWidth[#ColumnLineWidth], data.height)
	
	lg.setColor(255, 255, 255, 192)
	--lg.draw(skin.sprites.maniaStageLeft, ColumnLineWidth[1] + skin.config.ColumnStart[keymode] - skin.sprites.maniaStageLeft:getWidth(), 0, 0)
	--lg.draw(skin.sprites.maniaStageRight, globalscale * coveerWidth + ColumnLineWidth[1] + skin.config.ColumnStart[keymode], 0, 0)
	--lg.draw(skin.sprites.scorebarBG, globalscale * coveerWidth + 2, data.height, -math.pi/2, 0.7, 0.7)
	--lg.draw(skin.sprites.scorebarColour, globalscale * coveerWidth + 3 + 0.7*(skin.sprites.scorebarBG:getWidth() - skin.sprites.scorebarColour:getWidth()), data.height - 5, -math.pi/2, 0.7, 0.7)
	lg.setColor(255, 255, 255, 255)

end

function osuClass.loadSkin(self, name)
	skin = data.skin
	offset = data.config.offset
	skin.sprites = {
		mania = {
			key = {
			},
			note = {
			},
			sustain = {
			},
		}
	}
	skin.config = require(name)
	for i = 1, #skin.config.Colours do
		skin.sprites.mania.key[i] = lg.newImage(name .. "/" .. skin.config.Colours[i].KeyImage)
	end
	for i = 1, #skin.config.Colours do
		skin.sprites.mania.note[i] = lg.newImage(name .. "/" .. skin.config.Colours[i].NoteImage)
	end
	for i = 1, #skin.config.Colours do
		skin.sprites.mania.sustain[i] = lg.newImage(name .. "/" .. skin.config.Colours[i].NoteImageL)
	end
	skin.sprites.maniaStageRight = lg.newImage(name .. "/mania-stage-right.png")
	skin.sprites.maniaStageLeft = lg.newImage(name .. "/mania-stage-left.png")
	--skin.sprites.scorebarColour = lg.newImage(name .. "/scorebar-colour.png")
	--skin.sprites.scorebarBG = lg.newImage(name .. "/scorebar-bg.png")
	skin.sprites.background = lg.newImage(name .. "/menu-background.png")
	
	skin.sampleSet = {}
	--for i,hs in pairs(skin.config.HitSounds[data.config.sampleSet]) do
	--	skin.sampleSet[i] = love.audio.newSource(name .. "/" .. skin.config.HitSoundsFolder .. "/" .. hs)
	--end

end

function osuClass.clearStats(self)
	data.stats.hits = {0,0,0,0,0,0}
	data.stats.combo = 0
	data.stats.maxcombo = 0
	data.stats.speed = nil
end 

osuClass.convertBeatmap = require "src.converters.convert"

function osuClass.loadBeatmap(self, cache)
	self:convertBeatmap(cache)
	self:clearStats()
end

function osuClass.reloadBeatmap(self)
	self:loadBeatmap(data.cache[data.currentbeatmap])
end

osuClass.genCache = require "src.cache.genCache"





