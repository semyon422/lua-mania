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
	
	lg.setColor(255, 255, 255, 255)
	if data.ui.debug == false then
		lg.print(
			"FPS: "..love.timer.getFPS().."\n"..
			"time: " .. math.floor(beatmap.audio:tell()*10)/10 .. "\n" ..
			"speed: " .. data.config.speed .. "\n" ..
			"offset: " .. data.config.offset .. "\n" ..
			"HitObjects: " .. data.beatmap.HitObjectsCount .. "\n" ..
			"miss: " .. data.stats.hits[6] .. "\n" ..
			"50: " .. data.stats.hits[5] .. "\n" ..
			"100: " .. data.stats.hits[4] .. "\n" ..
			"200: " .. data.stats.hits[3] .. "\n" ..
			"300: " .. data.stats.hits[2] .. "\n" ..
			"MAX: " .. data.stats.hits[1] .. "\n" ..
			"Combo: " .. data.stats.combo .. "\n"
		, 0, 0, 0, 1, 1)
	else
		lg.print(
			"FPS: "..love.timer.getFPS().."\n"..
			"scroll: " .. data.stats.currentTime .. "\n" ..
			"speed: " .. data.config.speed .. "\n" ..
			"notes: " .. data.drawedNotes .. "\n"
		, 0, 0, 0,1,1)
	end
	lg.setColor(255, 255, 255, 255)
end

function osuClass.beat(self, state)
	if state == 1 then
		--data.debugscale = 0.85
	elseif state == 0 then
		--if data.debugscale < 1 then data.debugscale = data.debugscale + 0.002 end
	end
	
end

function osuClass.start(self)
	beatmap.audio:stop()
	beatmap.audio:play()
	beatmap.audio:pause()
	data.starttime = love.timer.getTime() * 1000
	data.stats.currentTime = 0
	data.play = 1
	data.state = "started"
	beatmap.audio:play()
	beatmap.audio:setPitch(data.config.pitch)
end
function osuClass.stop(self)
	beatmap.audio:stop()
	data.play = 0
	data.stats.currentTime = 0
	data.state = "stopped"
end
function osuClass.play(self)
	if data.state == "paused" then
		data.play = 1
		data.state = "started"
		beatmap.audio:play()
	else
		self:start()
	end
end
function osuClass.pause(self)
	data.play = 2
	data.state = "paused"
	beatmap.audio:pause()
end

function osuClass.hit(self, ms, key, rm)
	local trueMs = ms + data.config.offset
	for i = 1, #data.od do
		if math.abs(trueMs) <= data.od[i] then 
			data.stats.lastHit = i
			data.stats.hits[i] = data.stats.hits[i] + 1
			if i == #data.od then data.stats.combo = 0 end
			break
		end
	end
	if math.abs(trueMs) <= data.od[#data.od - 1] then 
		if data.stats.averageMismatch.count >= data.stats.averageMismatch.maxCount then
			data.stats.averageMismatch.value =  math.floor((data.stats.averageMismatch.value * (data.stats.averageMismatch.count - 1) + ms) / (data.stats.averageMismatch.count))
		else
			data.stats.averageMismatch.value = math.floor((data.stats.averageMismatch.value * data.stats.averageMismatch.count + ms) / (data.stats.averageMismatch.count + 1))
			data.stats.averageMismatch.value = data.stats.averageMismatch.value + 1
		end
		
		--data.config.offset = -1 * data.stats.averageMismatch.value
		table.insert(data.stats.mismatch, trueMs)
		
		data.stats.combo = data.stats.combo + 1
		data.keyhits[key] = 1
	end
end

function osuClass.keyboard(self)
	local dt = data.dt
	local hud = data.hud
	local beatmap = data.beatmap

	local keyboard = data.keyboard

	if love.keyboard.isDown(keyboard.key.pause) then
		data.ui.simplemenu.onscreen = true
		data.ui.simplemenu.state = "pause"
		osu:pause()
	end
	if love.keyboard.isDown(keyboard.key.retry) then
		osu:stop()
		data.beatmap = {}
		osu:reloadBeatmap()
		osu:start()
		data.ui.simplemenu.onscreen = false
	end
	
	if love.keyboard.isDown(keyboard.key.speedup) then
		if data.keylocks[keyboard.key.speedup] == nil then
			data.config.speed = data.config.speed + 0.1
		end
		data.keylocks[keyboard.key.speedup] = 1
	else
		data.keylocks[keyboard.key.speedup] = nil
	end
	if love.keyboard.isDown(keyboard.key.speeddown) then
		if data.keylocks[keyboard.key.speeddown] == nil then
			if data.config.speed > 0.2 then data.config.speed = data.config.speed - 0.1 end
		end
		data.keylocks[keyboard.key.speeddown] = 1
	else
		data.keylocks[keyboard.key.speeddown] = nil
	end
	
	if love.keyboard.isDown(keyboard.key.offsetup) then
		if data.keylocks[keyboard.key.offsetup] == nil then
			data.config.offset = data.config.offset + 5
		end
		data.keylocks[keyboard.key.offsetup] = 1
	else
		data.keylocks[keyboard.key.offsetup] = nil
	end
	if love.keyboard.isDown(keyboard.key.offsetdown) then
		if data.keylocks[keyboard.key.offsetdown] == nil then
			data.config.offset = data.config.offset - 5
		end
		data.keylocks[keyboard.key.offsetdown] = 1
	else
		data.keylocks[keyboard.key.offsetdown] = nil
	end
	
	if love.keyboard.isDown(keyboard.key.songup) then
		if data.keylocks[keyboard.key.songup] == nil then
			if data.ui.songlist.scroll < 2 and data.ui.songlist.scroll >= -#data.cache + 3 then data.ui.songlist.scroll = data.ui.songlist.scroll + 1 end
		end
		data.keylocks[keyboard.key.songup] = 1
	else
		data.keylocks[keyboard.key.songup] = nil
	end
	if love.keyboard.isDown(keyboard.key.songdown) then
		if data.keylocks[keyboard.key.songdown] == nil then
			if data.ui.songlist.scroll <= 2 and data.ui.songlist.scroll > -#data.cache + 3 then data.ui.songlist.scroll = data.ui.songlist.scroll - 1 end
		end
		data.keylocks[keyboard.key.songdown] = 1
	else
		data.keylocks[keyboard.key.songdown] = nil
	end
	
	if love.keyboard.isDown(keyboard.key.enter) then
		if data.keylocks[keyboard.key.enter] == nil then
			data.ui.simplemenu.onscreen = false
			data.currentbeatmap = data.ui.songlist.current
			self:reloadBeatmap()
			self:play()
			data.ui.state = 3
		end
		data.keylocks[keyboard.key.enter] = 1
	else
		data.keylocks[keyboard.key.enter] = nil
	end
	
	if data.beatmap.General ~= nil then
		for keynumber,key in pairs(keyboard.maniaLayouts[tonumber(data.beatmap.General["CircleSize"])]) do
			if love.keyboard.isDown(key) then
				if data.keylocks[keynumber] == 0 then
					if data.beatmap.currentNote[keynumber] ~= nil then
						self:hit(data.beatmap.currentNote[keynumber][2] - data.stats.currentTime, keynumber)
					end
				end
				data.keylocks[keynumber] = 1
			else
				data.keylocks[keynumber] = 0
				data.keyhits[keynumber] = 0
			end
		end
	end
	
	
	if beatmap.audio ~= nil then
		if data.play == 1 then
			data.stats.currentTime =  math.floor(beatmap.audio:tell() * 1000)
			--data.stats.currentTime = math.floor(love.timer.getTime() * 1000 - data.starttime)
		elseif data.play == 2 then
			data.stats.currentTime = math.floor(beatmap.audio:tell() * 1000)
			data.starttime = math.floor(love.timer.getTime() * 1000 - data.stats.currentTime)
		end
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
	local scroll = data.stats.currentTime
	local speed = data.config.speed
	local skin = data.skin
	local offset = data.config.offset
	local hitPosition = data.config.hitPosition
	local globalscale = data.config.globalscale
	
	keymode = tonumber(beatmap.General["CircleSize"])
	
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
	update(1)
	scale.y = globalscale * ColumnWidth[1] / drawable.note:getWidth()
	
	data.drawedNotes = 0
	for notetime = scroll - 200 - math.ceil(hitPosition/speed) - math.ceil(drawable.note:getHeight()*scale.y/speed), scroll + data.height / speed do
		note = beatmap.HitObjects[notetime]
		if note ~= nil then
			for j = 1, keymode do 
				if note[j] ~= nil then
					if note[j][1][1] == 1 then --OK
						if note[j][1][2] == 0 then
							if notetime + offset <= scroll + data.od[1] and data.beatmap.currentNote[j] ~= nil then
								if beatmap.HitObjects[data.beatmap.currentNote[j][2]] == nil then
									beatmap.HitObjects[data.beatmap.currentNote[j][2]] = {}
								end
								beatmap.HitObjects[data.beatmap.currentNote[j][2]][j] = data.beatmap.currentNote[j]
								beatmap.HitObjects[data.beatmap.currentNote[j][2]][j][1][2] = 2
								data.beatmap.currentNote[j] = nil
							elseif notetime + offset <= scroll + data.od[#data.od] and notetime + offset > scroll - data.od[1] and data.beatmap.currentNote[j] == nil then
								data.beatmap.currentNote[j] = {note[j][1], note[j][2], note[j][3], note[j][4]}
								note[j] = nil
							elseif note[j][1][1] == 1 then
								update(j)
								lg.setColor(255,255,255,255)
								lg.draw(drawable.note, x, data.height - hitPosition - offset * speed - (notetime - scroll) * speed - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
							end
						end
						if note[j] ~= nil then
							if note[j][1][2] == 2 then
								update(j)
								lg.setColor(255,255,255,128)
								lg.draw(drawable.note, x, data.height - hitPosition - offset * speed - (notetime - scroll) * speed - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
								lg.setColor(255,255,255,255)
							end
						end
					end
					if note[j] ~= nil then
						if note[j][1][1] == 2 then
							if note[j][1][2] == 0 then
								if notetime + offset <= scroll + data.od[1] and data.beatmap.currentNote[j] ~= nil then
									if beatmap.HitObjects[data.beatmap.currentNote[j][2]] == nil then
										beatmap.HitObjects[data.beatmap.currentNote[j][2]] = {}
									end
									beatmap.HitObjects[data.beatmap.currentNote[j][2]][j] = data.beatmap.currentNote[j]
									beatmap.HitObjects[data.beatmap.currentNote[j][2]][j][1][2] = 2
									data.beatmap.currentNote[j] = nil
								elseif notetime + offset <= scroll + data.od[#data.od] and notetime + offset > scroll - data.od[1] and data.beatmap.currentNote[j] == nil then
									data.beatmap.currentNote[j] = {note[j][1], note[j][2], note[j][3], note[j][4]}
									note[j] = nil
								else
									update(j)
									lg.setColor(255,255,255,255)
									lg.draw(drawable.slider, x, data.height - hitPosition - offset * speed - (note[j][3] - scroll) * speed, 0, scale.x, (note[j][3] - notetime)/drawable.slider:getHeight() * speed)
									lg.draw(drawable.note, x, data.height - hitPosition - offset * speed - (notetime - scroll) * speed - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
									lg.draw(drawable.note, x, data.height - hitPosition - offset * speed - (note[j][3] - scroll) * speed - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
								end
							elseif note[j][1][2] == 2 then
								local hiddenTime = scroll - math.ceil(hitPosition/speed) - math.ceil(drawable.note:getHeight()*scale.y/speed)
								if note[j][2] > note[j][3] then
									beatmap.HitObjects[notetime][j] = nil
								elseif note[j][2] < hiddenTime then
									if note[j][2] < hiddenTime then
										if beatmap.HitObjects[hiddenTime] == nil then
											beatmap.HitObjects[hiddenTime] = {}
										end
										beatmap.HitObjects[hiddenTime][j] = note[j]
										beatmap.HitObjects[hiddenTime][j][2] = hiddenTime
										beatmap.HitObjects[notetime][j] = nil
										note[j] = nil
									end
								elseif note[j][2] == hiddenTime then
									update(j)
									lg.setColor(255,255,255,128)
									lg.draw(drawable.slider, x, data.height - hitPosition - offset * speed - (note[j][3] - scroll) * speed, 0, scale.x, (note[j][3] - note[j][2])/drawable.slider:getHeight() * speed)
									if note[j][2] > scroll - math.ceil(hitPosition/speed) - math.ceil(drawable.note:getHeight()*scale.y/speed) then
										lg.draw(drawable.note, x, data.height - hitPosition - offset * speed - (note[j][2] - scroll) * speed - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
									end
									lg.draw(drawable.note, x, data.height - hitPosition - offset * speed - (note[j][3] - scroll) * speed - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
									lg.setColor(255,255,255,255)
								else
									update(j)
									lg.setColor(255,255,255,128)
									lg.draw(drawable.slider, x, data.height - hitPosition - offset * speed - (note[j][3] - scroll) * speed, 0, scale.x, (note[j][3] - note[j][2])/drawable.slider:getHeight() * speed)
									if note[j][2] > scroll - math.ceil(hitPosition/speed) - math.ceil(drawable.note:getHeight()*scale.y/speed) then
										lg.draw(drawable.note, x, data.height - hitPosition - offset * speed - (note[j][2] - scroll) * speed - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
									end
									lg.draw(drawable.note, x, data.height - hitPosition - offset * speed - (note[j][3] - scroll) * speed - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
									lg.setColor(255,255,255,255)
								end
							end
						end
					end
				end
			end
		end
	end
	lg.setColor(255,255,255,255)
	for j = 1, keymode do 
		if data.beatmap.currentNote[j] ~= nil then
			if data.beatmap.currentNote[j][1][1] == 1 then
				if data.beatmap.currentNote[j][1][2] == 0 then	update(j)
						lg.draw(drawable.note, x, data.height - hitPosition - offset * speed - (data.beatmap.currentNote[j][2] - scroll) * speed - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
					
					if data.beatmap.currentNote[j][2] + offset < scroll - data.od[#data.od - 1] then
						data.stats.combo = 0
						data.stats.hits[6] = data.stats.hits[6] + 1
						if beatmap.HitObjects[data.beatmap.currentNote[j][2]] == nil then
							beatmap.HitObjects[data.beatmap.currentNote[j][2]] = {}
						end
						beatmap.HitObjects[data.beatmap.currentNote[j][2]][j] = data.beatmap.currentNote[j]
						beatmap.HitObjects[data.beatmap.currentNote[j][2]][j][1][2] = 2
						data.beatmap.currentNote[j] = nil
					elseif data.keyhits[j] == 1 then
						if data.beatmap.currentNote[j][2] + offset > scroll + data.od[#data.od - 1] then
							data.stats.combo = 0
							data.stats.hits[6] = data.stats.hits[6] + 1
							data.beatmap.currentNote[j][1][2] = 2
						else
							data.beatmap.currentNote[j][1][2] = 1
						end
					else
					end
				elseif data.beatmap.currentNote[j][1][2] == 1 then
					data.beatmap.currentNote[j] = nil
					data.keyhits[j] = 0
				elseif data.beatmap.currentNote[j][1][2] == 2 then
					if data.beatmap.currentNote[j][2] + offset <= scroll then
						if beatmap.HitObjects[data.beatmap.currentNote[j][2]] == nil then
							beatmap.HitObjects[data.beatmap.currentNote[j][2]] = {}
						end
						beatmap.HitObjects[data.beatmap.currentNote[j][2]][j] = data.beatmap.currentNote[j]
						beatmap.HitObjects[data.beatmap.currentNote[j][2]][j][1][2] = 2
						data.beatmap.currentNote[j] = nil
						data.keyhits[j] = 0
					else
						update(j)
						lg.setColor(255,255,255,128)
						lg.draw(drawable.note, x, data.height - hitPosition - offset * speed - (data.beatmap.currentNote[j][2] - scroll) * speed - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
						lg.setColor(255,255,255,255)
					end
				end
			elseif data.beatmap.currentNote[j][1][1] == 2 then
				if data.beatmap.currentNote[j][1][2] == 0 then
					if data.keyhits[j] == 1 and math.abs(data.beatmap.currentNote[j][2] + offset - data.stats.currentTime) <= data.od[#data.od - 1] then
						data.beatmap.currentNote[j][1][2] = 1
					elseif data.keyhits[j] == 1 and data.beatmap.currentNote[j][2] + offset < scroll - data.od[#data.od - 1] then
						data.stats.combo = 0
						data.stats.hits[6] = data.stats.hits[6] + 1
						data.beatmap.currentNote[j][1][2] = 2
					elseif data.beatmap.currentNote[j][3] + offset < scroll - data.od[#data.od - 1] then
						data.stats.combo = 0
						data.stats.hits[6] = data.stats.hits[6] + 1
						data.beatmap.currentNote[j][1][2] = 2
					else
						update(j)
						local lnscale = (data.beatmap.currentNote[j][3] - data.beatmap.currentNote[j][2])/drawable.slider:getHeight() * speed
						
						lg.draw(drawable.slider, x, data.height - hitPosition - offset * speed - (data.beatmap.currentNote[j][3] - scroll) * speed, 0, scale.x, lnscale)
						lg.draw(drawable.note, x, data.height - hitPosition - offset * speed - (data.beatmap.currentNote[j][2] - scroll) * speed - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
						lg.draw(drawable.note, x, data.height - hitPosition - offset * speed - (data.beatmap.currentNote[j][3] - scroll) * speed - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
					end
				end
				if data.beatmap.currentNote[j][1][2] == 1 then
					if data.keylocks[j] == 0 and math.abs(data.beatmap.currentNote[j][3] + offset - data.stats.currentTime) > data.od[#data.od - 1] then
						data.stats.combo = 0
						data.stats.hits[6] = data.stats.hits[6] + 1
						data.beatmap.currentNote[j][1][2] = 2
						data.keyhits[j] = 0
					elseif data.keylocks[j] == 0 and math.abs(data.beatmap.currentNote[j][3] + offset - data.stats.currentTime) <= data.od[#data.od - 1] then
						self:hit(data.beatmap.currentNote[j][3] - data.stats.currentTime, j, 1)
						data.beatmap.currentNote[j] = nil
						data.keyhits[j] = 0
					elseif data.keylocks[j] == 1 and data.beatmap.currentNote[j][3] + offset - data.stats.currentTime <= -1 * data.od[#data.od - 3] then
						self:hit(data.beatmap.currentNote[j][3] - data.stats.currentTime, j, 1)
						data.beatmap.currentNote[j] = nil
						data.keyhits[j] = 0
					else
						update(j)
						if data.beatmap.currentNote[j][2] + offset <= scroll and data.beatmap.currentNote[j][3] + offset > scroll then
							local lnscale = (data.beatmap.currentNote[j][3] + offset - scroll)/drawable.slider:getHeight() * speed
							lg.draw(drawable.slider, x, data.height - hitPosition - offset * speed - (data.beatmap.currentNote[j][3] - scroll) * speed, 0, scale.x, lnscale)
							lg.draw(drawable.note, x, data.height - hitPosition - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
							lg.draw(drawable.note, x, data.height - hitPosition - offset * speed - (data.beatmap.currentNote[j][3] - scroll) * speed - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
							data.beatmap.currentNote[j][2] = scroll - offset
						elseif data.beatmap.currentNote[j][2] + offset <= scroll and data.beatmap.currentNote[j][3] + offset <= scroll then
						elseif data.beatmap.currentNote[j][2] + offset > scroll then
							local lnscale = (data.beatmap.currentNote[j][3] - data.beatmap.currentNote[j][2])/drawable.slider:getHeight() * speed
							lg.draw(drawable.slider, x, data.height - hitPosition - offset * speed - (data.beatmap.currentNote[j][3] - scroll) * speed, 0, scale.x, lnscale)
							lg.draw(drawable.note, x, data.height - hitPosition - offset * speed - (data.beatmap.currentNote[j][2] - scroll) * speed - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
							lg.draw(drawable.note, x, data.height - hitPosition - offset * speed - (data.beatmap.currentNote[j][3] - scroll) * speed - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
						end
					end
				elseif data.beatmap.currentNote[j][1][2] == 2 then
				
						update(j)
						local lnscale = (data.beatmap.currentNote[j][3] - data.beatmap.currentNote[j][2])/drawable.slider:getHeight() * speed
						lg.setColor(255,255,255,128)
						lg.draw(drawable.slider, x, data.height - hitPosition - offset * speed - (data.beatmap.currentNote[j][3] - scroll) * speed, 0, scale.x, lnscale)
						lg.draw(drawable.note, x, data.height - hitPosition - offset * speed - (data.beatmap.currentNote[j][2] - scroll) * speed - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
						lg.draw(drawable.note, x, data.height - hitPosition - offset * speed - (data.beatmap.currentNote[j][3] - scroll) * speed - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
						lg.setColor(255,255,255,255)
					if data.keylocks[j] == 0 and math.abs(data.beatmap.currentNote[j][3] + offset - data.stats.currentTime) > data.od[#data.od - 1] then
						data.stats.combo = 0
						data.keyhits[j] = 0
					end
					if data.keylocks[j] == 0 and data.beatmap.currentNote[j][3] + offset <= scroll - data.od[#data.od - 1] then
						local hiddenTime = scroll - math.ceil(hitPosition/speed) - math.ceil(drawable.note:getHeight()*scale.y/speed)
						if data.beatmap.currentNote[j][2] < hiddenTime then
							if beatmap.HitObjects[hiddenTime] == nil then
								beatmap.HitObjects[hiddenTime] = {}
							end
							beatmap.HitObjects[hiddenTime][j] = data.beatmap.currentNote[j]
							beatmap.HitObjects[hiddenTime][j][2] = hiddenTime
						else
							if beatmap.HitObjects[data.beatmap.currentNote[j][2]] == nil then
								beatmap.HitObjects[data.beatmap.currentNote[j][2]] = {}
							end
							beatmap.HitObjects[data.beatmap.currentNote[j][2]][j] = data.beatmap.currentNote[j]
						end
						data.beatmap.currentNote[j] = nil
						data.keyhits[j] = 0
					elseif data.beatmap.currentNote[j][3] + offset <= scroll - hitPosition/speed then
						data.beatmap.currentNote[j] = nil
						data.keyhits[j] = 0
					else
					end
				end
			end
		end
	end
end

function osuClass.drawUI(self)
	beatmap = data.beatmap
	skin = data.skin
	offset = data.config.offset
	globalscale = data.config.globalscale
	
	keymode = tonumber(beatmap.General["CircleSize"])
	
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

end

function osuClass.convertBeatmap(self)
	beatmap = data.beatmap
	beatmap.raw = {}
	beatmap.raw.file = io.open(beatmap.pathFile, "r")
	beatmap.raw.array = {}
	beatmap.raw.HitObjects = {}
	beatmap.raw.General = {}
	beatmap.HitObjects = {}
	beatmap.HitObjectsCount = 0
	beatmap.General = {}
	for line in beatmap.raw.file:lines() do
		table.insert(beatmap.raw.array, line)
	end
	beatmap.raw.file:close()
	for globalLine = 1, #beatmap.raw.array do
		if --#explode("General", beatmap.raw.array[globalLine]) == 2 or
		--#explode("Editor", beatmap.raw.array[globalLine]) == 2 or
		--#explode("Metadata", beatmap.raw.array[globalLine]) == 2 or
		#explode("Difficulty]", beatmap.raw.array[globalLine]) == 2 then
			for offset = globalLine + 1, #beatmap.raw.array - globalLine do
				if string.find(beatmap.raw.array[offset], "[", 1, true) then
					break
				end
				localLine = offset - globalLine
				beatmap.raw.General[localLine] = explode(":", beatmap.raw.array[offset])
				beatmap.General[localLine] = {}
				beatmap.General[beatmap.raw.General[localLine][1]] = beatmap.raw.General[localLine][2]
			end
		end
		if #explode("HitObjects", beatmap.raw.array[globalLine]) == 2 then
			keymode = tonumber(beatmap.General["CircleSize"])
			interval = 512/keymode
			for offset = globalLine + 1, #beatmap.raw.array do
				local time = nil
				local key = nil
				local type = {1, 0}
				local endtime = nil
				local hitsound = nil
				
				localLine = offset - globalLine
				beatmap.raw.HitObjects[localLine] = explode(",", beatmap.raw.array[offset])
				
				time = tonumber(beatmap.raw.HitObjects[localLine][3])
				if time == nil then break end
				if beatmap.HitObjects[time] == nil then
					beatmap.HitObjects[time] = {}
				end
				
				beatmap.raw.HitObjects[localLine][1] = tonumber(beatmap.raw.HitObjects[localLine][1])
				for nkey = 1, keymode do
					if beatmap.raw.HitObjects[localLine][1] >= nkey * interval - interval and beatmap.raw.HitObjects[localLine][1] < nkey * interval then
						key = nkey
					end
				end
				
				type[1] = 1
				if beatmap.raw.HitObjects[localLine][4] == "128" then
					type[1] = 2
					endtime = tonumber(explode(":", beatmap.raw.HitObjects[localLine][6])[1])
				end
				
				beatmap.HitObjects[time][key] = {type, time, endtime, hitsound}
				beatmap.HitObjectsCount = beatmap.HitObjectsCount + 1
			end
		end
	end
end

function osuClass.loadBeatmap(self, cache)
	data.beatmap = {}
	beatmap = data.beatmap
	beatmap.path = cache.path
	beatmap.pathFile = cache.pathFile
	beatmap.pathAudio = cache.pathAudio
	beatmap.title = cache.title
	beatmap.artist = cache.artist
	beatmap.difficulity = cache.difficulity
	beatmap.audio = love.audio.newSource(cache.pathAudio)
	
	self:convertBeatmap()
	
	beatmap.currentNote = {}
	
	data.stats.hits = {0,0,0,0,0,0}
	combo = 0
end

function osuClass.reloadBeatmap(self)
	self:loadBeatmap(data.cache[data.currentbeatmap])
end


function osuClass.getBeatmapFileList(self) 
	local cd = ""
	for out in io.popen("echo %CD%"):lines() do
		cd = out
		break
	end
	for file in io.popen("dir /B /S /OD /A-D res\\Songs"):lines() do
		if #explode(".osu", tostring(file)) == 2 then
			table.insert(data.BMFList, {tostring(explode("\\", explode(cd .. "\\res\\Songs\\", file)[2])[1]), tostring(explode("\\", explode(cd .. "\\res\\Songs\\", file)[2])[2])})
		end
	end
end

function osuClass.generateBeatmapCache(self)
	cache = data.cache
	local BMFList = data.BMFList
	for index,info in pairs(BMFList) do
		local raw = io.open("res/Songs/" .. info[1] .. "/" .. info[2], "r")
		local rawTable = {}
		for line in raw:lines() do
			table.insert(rawTable, line)
		end
		raw:close()
		local title = ""
		local artist = ""
		local audio = ""
		local difficulity = ""
		local creator = ""
		local source = ""
		for gLine = 1, #rawTable do
			if explode(":", tostring(rawTable[gLine]))[1] == "AudioFilename" then
				audio = trim(tostring(explode(":", tostring(rawTable[gLine]))[2]))
			end
			if explode(":", tostring(rawTable[gLine]))[1] == "Title" then
				title = trim(tostring(explode(":", tostring(rawTable[gLine]))[2]))
			end
			if explode(":", tostring(rawTable[gLine]))[1] == "Artist" then
				artist = trim(tostring(explode(":", tostring(rawTable[gLine]))[2]))
			end
			if explode(":", tostring(rawTable[gLine]))[1] == "Version" then
				difficulity = trim(tostring(explode(":", tostring(rawTable[gLine]))[2]))
			end
			if explode(":", tostring(rawTable[gLine]))[1] == "Creator" then
				creator = trim(tostring(explode(":", tostring(rawTable[gLine]))[2]))
			end
			if explode(":", tostring(rawTable[gLine]))[1] == "Source" then
				source = trim(tostring(explode(":", tostring(rawTable[gLine]))[2]))
				if source == "" then source = "No source" end
			end
			if #explode("HitObjects", tostring(rawTable[gLine])) == 2 then
				break
			end
		end
		table.insert(cache, {
			title = title,
			artist = artist,
			difficulity = difficulity,
			audio = audio,
			pathAudio = "res/Songs/" .. info[1] .. "/" .. audio,
			pathFile = "res/Songs/" .. info[1] .. "/" .. info[2],
			path = "res/Songs/" .. info[1],
			creator = creator,
			source = source
			})
	end
end



