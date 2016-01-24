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
	self.data = init
	return self
end

function osuClass.drawHUD(self)
	local hud = self.data.hud
	local dt = self.data.dt
	
	lg.setColor(255, 255, 255, 255)
	if self.data.ui.debug == false then
		lg.print(
			"FPS: "..love.timer.getFPS().."\n"..
			"time: " .. math.floor(beatmap.audio:tell()*10)/10 .. "\n" ..
			"speed: " .. self.data.speed .. "\n" ..
			"mark: " .. self.data.mark .. "\n" ..
			"miss: " .. self.data.marks[6] .. "\n" ..
			"50: " .. self.data.marks[5] .. "\n" ..
			"100: " .. self.data.marks[4] .. "\n" ..
			"200: " .. self.data.marks[3] .. "\n" ..
			"300: " .. self.data.marks[2] .. "\n" ..
			"MAX: " .. self.data.marks[1] .. "\n" ..
			"Combo: " .. self.data.combo
		, 0, 0, 0, 1, 1)
	else
		lg.print(
			"FPS: "..love.timer.getFPS().."\n"..
			"scroll: " .. self.data.scroll .. "\n" ..
			"speed: " .. self.data.speed .. "\n" ..
			"notes: " .. self.data.drawedNotes .. "\n"
		, 0, 0, 0, self.data.debugscale, self.data.debugscale)
	end
	lg.setColor(255, 255, 255, 255)
end

function osuClass.beat(self, state)
	if state == 1 then
		self.data.debugscale = 0.85
	elseif state == 0 then
		if self.data.debugscale < 1 then self.data.debugscale = self.data.debugscale + 0.002 end
	end
	
end

function osuClass.start(self)
	beatmap.audio:stop()
	beatmap.audio:play()
	beatmap.audio:pause()
	self.data.starttime = love.timer.getTime() * 1000
	self.data.scroll = 0
	self.data.play = 1
	self.data.state = "started"
	beatmap.audio:play()
end
function osuClass.stop(self)
	beatmap.audio:stop()
	self.data.play = 0
	self.data.scroll = 0
	self.data.state = "stopped"
end
function osuClass.play(self)
	if self.data.state == "paused" then
		self.data.play = 1
		self.data.state = "started"
		beatmap.audio:play()
	else
		self:start()
	end
end
function osuClass.pause(self)
	self.data.play = 2
	self.data.state = "paused"
	beatmap.audio:pause()
end

function osuClass.hit(self, ms, key, rm)
	for i = 1, #self.data.od do
		if math.abs(ms) <= self.data.od[i] then 
			self.data.mark = i
			self.data.marks[i] = self.data.marks[i] + 1
			if i == #self.data.od then self.data.combo = 0 end
			break
		end
	end
	if math.abs(ms) <= self.data.od[#self.data.od - 1] then 
		self.data.combo = self.data.combo + 1
		if self.data.currentnotes[key][1] == 2 then
			self.data.currentnotes[key][1] = 3
			self.data.currentnotes[key][4] = ms
		elseif self.data.currentnotes[key][1] == 3 and rm then
			self.data.currentnotes[key] = {}
		elseif self.data.currentnotes[key][1] == 3 then
			self.data.currentnotes[key][1] = 4
			self.data.currentnotes[key][4] = 0
		elseif self.data.currentnotes[key][1] == 4 then
			self.data.currentnotes[key][1] = 4
			self.data.currentnotes[key][4] = 0
		else
			self.data.currentnotes[key] = {}
		end
	end
end

function osuClass.keyboard(self)
	local dt = self.data.dt
	local hud = self.data.hud
	local beatmap = self.data.beatmap

	local keyboard = self.data.keyboard

	
	
	for keynumber,key in pairs(keyboard.maniaLayouts[4]) do
		if love.keyboard.isDown(key) then
			if self.data.keylocks[keynumber] == 0 then
				if self.data.currentnotes[keynumber][1] ~= nil then
					self:hit(self.data.currentnotes[keynumber][2] - self.data.scroll, keynumber)
				end
			end
			self.data.keylocks[keynumber] = 1
		else
			self.data.keylocks[keynumber] = 0
		end
	end
	
	

	if self.data.play == 1 then
		self.data.scroll =  math.floor(beatmap.audio:tell() * 1000)
		--self.data.scroll = math.floor(love.timer.getTime() * 1000 - self.data.starttime)
	elseif self.data.play == 2 then
		self.data.scroll = math.floor(beatmap.audio:tell() * 1000)
		self.data.starttime = math.floor(love.timer.getTime() * 1000 - self.data.scroll)
	end
end



function osuClass.drawBackground(self)
	local background = self.data.skin.sprites.background
	local darkness = self.data.darkness
	local skin = self.data.skin
	
	--lg.setBackgroundColor(0, 0, 0)
	if skin.config.background.draw then
		scale = 1
		if self.data.width < background:getWidth() * scale then
			-- nothing
		end
		if self.data.height < background:getHeight() * scale then
			scale = self.data.height / background:getHeight()
		end
		if self.data.width > background:getWidth() * scale then
			scale = self.data.width / background:getWidth()
		end
		if self.data.height > background:getHeight() * scale then
			scale = self.data.height / background:getHeight()
		end

		lg.draw(background, self.data.width / 2, self.data.height / 2, 0, scale, scale, background:getWidth() / 2, background:getHeight() / 2)
		
		lg.setColor(0, 0, 0, (darkness / 100) * 255)
		lg.rectangle("fill", 0, 0, self.data.width, self.data.height)
		lg.setColor(255, 255, 255, 255)
	end

	
end

function osuClass.drawNotes(self)
	local beatmap = self.data.beatmap
	local scroll = self.data.scroll
	local speed = self.data.speed
	local skin = self.data.skin
	local offset = self.data.offset
	local globalscale = self.data.globalscale
	local currentsliders = self.data.currentsliders
	
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
	
	self.data.drawedNotes = 0
	for notetime = scroll-200, scroll + self.data.height / speed do
		note = beatmap.HitObjects[notetime]
		for j = 1, keymode do 
			if note ~= nil then
				if note[j] ~= nil then
					if note[j][1] == 1 then
						
						if notetime <= scroll + self.data.od[#self.data.od] and self.data.currentnotes[j][1] == nil then
							self.data.currentnotes[j] = {note[j][1], note[j][2], note[j][3], note[j][4]}
							note[j][1] = 0
						end
						
						if note[j][1] == 1 then
							update(j)
							lg.draw(drawable.note, offset.x + x, offset.y + self.data.height - (notetime - scroll) * speed - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
							
							self.data.drawedNotes = self.data.drawedNotes + 1
						end
					end
					if note[j][1] == 2 then
					
						if notetime <= scroll + self.data.od[#self.data.od] and self.data.currentnotes[j][1] == nil then
							self.data.currentnotes[j] = {note[j][1], note[j][2], note[j][3], note[j][4]}
							note[j][1] = 0
						end
						
						if note[j][1] ~= 0 then
							update(j)
							
							lg.draw(drawable.slider, offset.x + x, offset.y + self.data.height - (note[j][3] - scroll) * speed, 0, scale.x, (note[j][3] - notetime - drawable.note:getHeight())/drawable.slider:getHeight() * speed)
							lg.draw(drawable.note, offset.x + x, offset.y + self.data.height - (notetime - scroll) * speed - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
							lg.draw(drawable.note, offset.x + x, offset.y + self.data.height - (note[j][3] - scroll) * speed - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
						end
					end
				end
			end
		end
	end
	for j = 1, keymode do 
		if self.data.currentnotes[j] ~= nil then
			if self.data.currentnotes[j][1] == 1 then
			
				if self.data.currentnotes[j][2] < scroll - self.data.od[#self.data.od - 1] then
					self.data.combo = 0
					self.data.marks[6] = self.data.marks[6] + 1
					self.data.currentnotes[j] = {}
				end
				
				if self.data.currentnotes[j][1] == 1 then
					update(j)
					lg.draw(drawable.note, offset.x + x, offset.y + self.data.height - (self.data.currentnotes[j][2] - scroll) * speed - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
					
					self.data.drawedNotes = self.data.drawedNotes + 1
				end
			end
			if self.data.currentnotes[j][1] == 2 then
				
				if self.data.currentnotes[j][2] < scroll - self.data.od[#self.data.od - 1] then
					if self.data.keylocks[j] == 1 then
						self.data.combo = 0
						self.data.marks[6] = self.data.marks[6] + 1
						self.data.currentnotes[j][1] = 3
					end
				end
				
				if self.data.currentnotes[j][3] < scroll - self.data.od[#self.data.od - 1] then
					self.data.combo = 0
					self.data.marks[6] = self.data.marks[6] + 1
					self.data.currentnotes[j] = {}
				end
				
				if self.data.currentnotes[j][1] == 2 then
					update(j)
					local lnscale = (self.data.currentnotes[j][3] - self.data.currentnotes[j][2] - drawable.note:getHeight()*scale.y)/drawable.slider:getHeight() * speed
					
					lg.draw(drawable.slider, offset.x + x, offset.y + self.data.height - (self.data.currentnotes[j][3] - scroll) * speed, 0, scale.x, lnscale)
					lg.draw(drawable.note, offset.x + x, offset.y + self.data.height - (self.data.currentnotes[j][2] - scroll) * speed - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
					lg.draw(drawable.note, offset.x + x, offset.y + self.data.height - (self.data.currentnotes[j][3] - scroll) * speed - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
				end
			end
			if self.data.currentnotes[j][1] == 3 then
				
				if self.data.keylocks[j] == 0 and math.abs(self.data.currentnotes[j][3] - self.data.scroll) > self.data.od[#self.data.od - 1] then
					self.data.combo = 0
					self.data.marks[6] = self.data.marks[6] + 1
					self.data.currentnotes[j][1] = 4
				end
				
				if self.data.keylocks[j] == 0 and math.abs(self.data.currentnotes[j][3] - self.data.scroll) <= self.data.od[#self.data.od - 1] then
					self:hit(self.data.currentnotes[j][3] - self.data.scroll, j, 1)
				end
				
				if self.data.keylocks[j] == 1 and self.data.scroll - self.data.currentnotes[j][3] > self.data.od[#self.data.od - 4] then
					self:hit(self.data.currentnotes[j][3] - self.data.scroll, j, 1)
				end
				
				if self.data.currentnotes[j][1] == 3 then
					update(j)
					local lnscale = (self.data.currentnotes[j][3] - scroll - self.data.currentnotes[j][4] - drawable.note:getHeight()*scale.y)/drawable.slider:getHeight() * speed
					--if self.data.currentnotes[j][2] > scroll then
						--lnscale = (self.data.currentnotes[j][3] - self.data.currentnotes[j][2] - drawable.note:getHeight()*scale.y)/drawable.slider:getHeight() * speed
						--lg.draw(drawable.slider, offset.x + x, offset.y + self.data.height - (self.data.currentnotes[j][3] - scroll) * speed, 0, scale.x, lnscale)
						--lg.draw(drawable.note, offset.x + x, offset.y + self.data.height - (self.data.currentnotes[j][2] - scroll) * speed - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
						--lg.draw(drawable.note, offset.x + x, offset.y + self.data.height - (self.data.currentnotes[j][3] - scroll) * speed - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
					--else
						lg.draw(drawable.slider, offset.x + x, offset.y + self.data.height - (self.data.currentnotes[j][3] - scroll) * speed, 0, scale.x, lnscale)
						lg.draw(drawable.note, offset.x + x, offset.y + self.data.height - self.data.currentnotes[j][4] * speed - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
						lg.draw(drawable.note, offset.x + x, offset.y + self.data.height - (self.data.currentnotes[j][3] - scroll) * speed - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
					--end
				end
			end
			if self.data.currentnotes[j][1] == 4 then
			
				if self.data.keylocks[j] == 0 and math.abs(self.data.currentnotes[j][3] - self.data.scroll) > self.data.od[#self.data.od - 1] then
					self.data.combo = 0
				end
				
				if self.data.keylocks[j] == 0 and self.data.currentnotes[j][3] - self.data.scroll <= -1 * self.data.od[#self.data.od - 1] then
					self.data.marks[5] = self.data.marks[5] + 1
					self.data.currentnotes[j] = {}
				end
				
				if self.data.currentnotes[j][1] == 4 then
					if self.data.currentnotes[j][3] < scroll - self.data.od[#self.data.od - 1] then
						self.data.currentnotes[j] = {}
					end
				end 
				
				if self.data.currentnotes[j][1] == 4 then
					update(j)
					local lnscale = (self.data.currentnotes[j][3] - scroll)/drawable.slider:getHeight() * speed
					
					if self.data.keylocks[j] == 1 and self.data.currentnotes[j][2] < scroll then
						lg.draw(drawable.note, offset.x + x, offset.y + self.data.height - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
						--lnscale = (self.data.currentnotes[j][3] - scroll - drawable.note:getHeight()*scale.y)/drawable.slider:getHeight() * speed
					end
					lg.draw(drawable.slider, offset.x + x, offset.y + self.data.height - (self.data.currentnotes[j][3] - scroll) * speed, 0, scale.x, lnscale)
					
					lg.draw(drawable.note, offset.x + x, offset.y + self.data.height - (self.data.currentnotes[j][3] - scroll) * speed - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
				end
			end
		end
	end
end

function osuClass.drawUI(self)
	beatmap = self.data.beatmap
	skin = self.data.skin
	offset = self.data.offset
	globalscale = self.data.globalscale
	
	
	keymode = tonumber(beatmap.General["CircleSize"])
	
	ColumnColours = skin.config.ManiaColours[keymode]
	ColumnWidth = skin.config.ColumnWidth[keymode]
	ColumnLineWidth = skin.config.ColumnLineWidth[keymode]
	
	coveerWidth = ColumnLineWidth[1]
	for i = 1, keymode do
		x = ColumnLineWidth[1] + skin.config.ColumnStart[keymode]
		for j = 1, i - 1 do
			x = x + ColumnWidth[j] + ColumnLineWidth[j + 1]
		end
		coveerWidth = coveerWidth + ColumnWidth[i] + ColumnLineWidth[i + 1]
		colourBG = skin.config.Colours[ColumnColours[i]].Colour
		lg.setColor(colourBG[1],
								colourBG[2],
								colourBG[3],
								colourBG[4])
		lg.rectangle("fill", globalscale * x + offset.x, 0, globalscale * ColumnWidth[i], self.data.height)
		colourLine = skin.config.ColourColumnLine
		lg.setColor(colourLine[1],
								colourLine[2],
								colourLine[3],
								colourLine[4])
		lg.rectangle("fill", globalscale * (x - ColumnLineWidth[1]) + offset.x, 0, globalscale * ColumnLineWidth[i], self.data.height)
	end
	lg.rectangle("fill", globalscale * (coveerWidth - ColumnLineWidth[1]) + offset.x, 0, globalscale * ColumnLineWidth[#ColumnLineWidth], self.data.height)
	

	lg.setColor(255, 255, 255, 192)
	--lg.draw(skin.sprites.maniaStageLeft, offset.x - skin.sprites.maniaStageLeft:getWidth(), 0, 0)
	--lg.draw(skin.sprites.maniaStageRight, globalscale * coveerWidth + offset.x, 0, 0)
	--lg.draw(skin.sprites.scorebarBG, globalscale * coveerWidth + offset.x + 2, self.data.height, -math.pi/2, 0.7, 0.7)
	--lg.draw(skin.sprites.scorebarColour, globalscale * coveerWidth + offset.x + 3 + 0.7*(skin.sprites.scorebarBG:getWidth() - skin.sprites.scorebarColour:getWidth()), self.data.height - 5, -math.pi/2, 0.7, 0.7)
	lg.setColor(255, 255, 255, 255)

end

function osuClass.loadSkin(self, name)
	skin = self.data.skin
	offset = self.data.offset
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

	offset.x = 0
end

function osuClass.convertBeatmap(self)
	beatmap = self.data.beatmap
	beatmap.raw = {}
	beatmap.raw.file = io.open(beatmap.path .. "/" .. beatmap.file, "r")
	beatmap.raw.array = {}
	beatmap.raw.HitObjects = {}
	beatmap.raw.General = {}
	beatmap.HitObjects = {}
	beatmap.General = {}
	for line in beatmap.raw.file:lines() do
		table.insert(beatmap.raw.array, line)
	end
	beatmap.raw.file:close()
	for globalLine = 1, #beatmap.raw.array do
		if #explode("General", beatmap.raw.array[globalLine]) == 2 or
		#explode("Editor", beatmap.raw.array[globalLine]) == 2 or
		#explode("Metadata", beatmap.raw.array[globalLine]) == 2 or
		#explode("Difficulty", beatmap.raw.array[globalLine]) == 2 or
		#explode("General", beatmap.raw.array[globalLine]) == 2 then
			for offset = globalLine + 1, #beatmap.raw.array - globalLine do
				localLine = offset - globalLine
				beatmap.raw.General[localLine] = explode(":", beatmap.raw.array[offset])
				beatmap.General[localLine] = {}
				beatmap.General[beatmap.raw.General[localLine][1]] = beatmap.raw.General[localLine][2]
				if string.find(beatmap.raw.array[offset], "[", 1, true) then
					break
				end
			end
		end
		beatmap.General["CircleSize"] = 4
		if #explode("HitObjects", beatmap.raw.array[globalLine]) == 2 then
			--[time] = {[key] = {type(0/1) (, endtime, hitsound)}, ...}
			keymode = tonumber(beatmap.General["CircleSize"])
			interval = 512/keymode
			beatmap.HitObjects.firstnote = tonumber(explode(",", beatmap.raw.array[globalLine + 1])[3])
			for offset = globalLine + 1, #beatmap.raw.array - globalLine do
				local time = nil
				local key = nil
				local type = nil
				local endtime = nil
				local timeoffset = 0
				
				localLine = offset - globalLine
				beatmap.raw.HitObjects[localLine] = explode(",", beatmap.raw.array[offset])
				
				time = tonumber(beatmap.raw.HitObjects[localLine][3])
				if beatmap.HitObjects[time] == nil then
					beatmap.HitObjects[time] = {}
				end
				
				beatmap.raw.HitObjects[localLine][1] = tonumber(beatmap.raw.HitObjects[localLine][1])
				for nkey = 1, keymode do
					if beatmap.raw.HitObjects[localLine][1] >= nkey * interval - interval and beatmap.raw.HitObjects[localLine][1] < nkey * interval then
						key = nkey
					end
				end
				
				type = 1
				if beatmap.raw.HitObjects[localLine][4] == "128" then
					type = 2
					endtime = tonumber(explode(":", beatmap.raw.HitObjects[localLine][6])[1])
				end
				
				beatmap.HitObjects[time][key] = {type, time, endtime, timeoffset}
				
				if string.find(beatmap.raw.array[offset], "[", 1, true) then
					break
				end
			end
		end
	end
end

function osuClass.loadBeatmap(self, path, file)
	beatmap = self.data.beatmap
	beatmap.path = path
	beatmap.file = file
	beatmap.audio = nil
	beatmap.raw = nil
	self:convertBeatmap()
end

function osuClass.reloadBeatmap(self, mapset, map)
	self:loadBeatmap(mappathprefix .. "res/Songs/" .. data.cache[mapset].folder, data.cache[mapset].maps[map])
	self.data.beatmap.audio = love.audio.newSource("res/Songs/" .. data.cache[mapset].folder .. "/" .. data.cache[mapset].audio)
end
