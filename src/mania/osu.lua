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
			"HitObjects: " .. self.data.beatmap.HitObjectsCount .. "\n" ..
			"miss: " .. self.data.marks[6] .. "\n" ..
			"50: " .. self.data.marks[5] .. "\n" ..
			"100: " .. self.data.marks[4] .. "\n" ..
			"200: " .. self.data.marks[3] .. "\n" ..
			"300: " .. self.data.marks[2] .. "\n" ..
			"MAX: " .. self.data.marks[1] .. "\n" ..
			"Combo: " .. self.data.combo .. "\n" ..
			"AvMs: " .. self.data.averageMs .. "\n" ..
			"offset: " .. self.data.offset .. "\n" ..
			"lsMs: " .. self.data.lastMs .. "\n" ..
			"mso: " .. self.data.mso .. "\n" ..
			"averageOffset: " .. self.data.averageOffset .. "\n"
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
	local mso = ms + self.data.offset
	self.data.mso = mso
	for i = 1, #self.data.od do
		if math.abs(mso) <= self.data.od[i] then 
			self.data.mark = i
			self.data.marks[i] = self.data.marks[i] + 1
			if i == #self.data.od then self.data.combo = 0 end
			break
		end
	end
	if math.abs(mso) <= self.data.od[#self.data.od - 1] then 
		if self.data.hitCount > 20 then
			self.data.averageMs =  math.floor((self.data.averageMs * (self.data.hitCount - 1) + ms) / (self.data.hitCount))
		else
			self.data.averageMs = math.floor((self.data.averageMs * self.data.hitCount + ms) / (self.data.hitCount + 1))
			self.data.hitCount = self.data.hitCount + 1
		end
		
		
		--self.data.offset = -1 * self.data.averageMs
		--self.data.offset = -1 * ms
		--self.data.offset = 0
		self.data.lastMs = ms
		
		
		self.data.averageOffset = math.floor((self.data.averageOffset * self.data.averageOffsetCount + self.data.averageMs) / (self.data.averageOffsetCount + 1))
		self.data.averageOffsetCount = self.data.averageOffsetCount + 1
		
		self.data.combo = self.data.combo + 1
		--self.data.offset = self.data.averageMs
		if self.data.currentnotes[key][1] == 2 then
			self.data.currentnotes[key][1] = 3
			self.data.currentnotes[key][4] = mso
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
		if self.data.keylocks[keyboard.key.speedup] == nil then
			data.speed = data.speed + 0.1
		end
		self.data.keylocks[keyboard.key.speedup] = 1
	else
		self.data.keylocks[keyboard.key.speedup] = nil
	end
	if love.keyboard.isDown(keyboard.key.speeddown) then
		if self.data.keylocks[keyboard.key.speeddown] == nil then
			if data.speed > 0.2 then data.speed = data.speed - 0.1 end
		end
		self.data.keylocks[keyboard.key.speeddown] = 1
	else
		self.data.keylocks[keyboard.key.speeddown] = nil
	end
	
	if love.keyboard.isDown(keyboard.key.offsetup) then
		if self.data.keylocks[keyboard.key.offsetup] == nil then
			data.offset = data.offset + 5
		end
		self.data.keylocks[keyboard.key.offsetup] = 1
	else
		self.data.keylocks[keyboard.key.offsetup] = nil
	end
	if love.keyboard.isDown(keyboard.key.offsetdown) then
		if self.data.keylocks[keyboard.key.offsetdown] == nil then
			data.offset = data.offset - 5
		end
		self.data.keylocks[keyboard.key.offsetdown] = 1
	else
		self.data.keylocks[keyboard.key.offsetdown] = nil
	end
	
	if data.beatmap.General ~= nil then
		for keynumber,key in pairs(keyboard.maniaLayouts[tonumber(data.beatmap.General["CircleSize"])]) do
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
	local hitPosition = self.data.hitPosition
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
	for notetime = scroll-200-math.ceil(hitPosition/speed), scroll + self.data.height / speed do
		note = beatmap.HitObjects[notetime]
		for j = 1, keymode do 
			if note ~= nil then
				if note[j] ~= nil then
					if note[j][1] == 1 then
						
						if notetime + offset <= scroll + self.data.od[#self.data.od] and notetime + offset >= scroll - self.data.od[#self.data.od - 1] and self.data.currentnotes[j][1] == nil then
							self.data.currentnotes[j] = {note[j][1], note[j][2], note[j][3], note[j][4]}
							note[j][1] = 0
						end
						
						if note[j][1] == 1 then
							update(j)
							lg.draw(drawable.note, x, self.data.height - hitPosition - offset * speed - (notetime - scroll) * speed - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
							
							self.data.drawedNotes = self.data.drawedNotes + 1
						end
					end
					if note[j][1] == 2 then
					
						if notetime + offset <= scroll + self.data.od[#self.data.od] and self.data.currentnotes[j][1] == nil then
							self.data.currentnotes[j] = {note[j][1], note[j][2], note[j][3], note[j][4]}
							note[j][1] = 0
						end
						
						if note[j][1] ~= 0 then
							update(j)
							
							lg.draw(drawable.slider, x, self.data.height - hitPosition - offset * speed - (note[j][3] - scroll) * speed, 0, scale.x, (note[j][3] - notetime - drawable.note:getHeight())/drawable.slider:getHeight() * speed)
							lg.draw(drawable.note, x, self.data.height - hitPosition - offset * speed - (notetime - scroll) * speed - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
							lg.draw(drawable.note, x, self.data.height - hitPosition - offset * speed - (note[j][3] - scroll) * speed - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
						end
					end
				end
			end
		end
	end
	for j = 1, keymode do 
		if self.data.currentnotes[j] ~= nil then
			if self.data.currentnotes[j][1] == 1 then
			
				if self.data.currentnotes[j][1] == 1 then
					update(j)
					lg.draw(drawable.note, x, self.data.height - hitPosition - offset * speed - (self.data.currentnotes[j][2] - scroll) * speed - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
					
					self.data.drawedNotes = self.data.drawedNotes + 1
				end
				if self.data.currentnotes[j][2] + offset < scroll - self.data.od[#self.data.od - 1] then
					self.data.combo = 0
					self.data.marks[6] = self.data.marks[6] + 1
					beatmap.HitObjects[self.data.currentnotes[j][2]][j][1] = 1
					self.data.currentnotes[j] = {}
				end
				
			end
			if self.data.currentnotes[j][1] == 2 then
				
				if self.data.currentnotes[j][2] + offset < scroll - self.data.od[#self.data.od - 1] then
					if self.data.keylocks[j] == 1 then
						self.data.combo = 0
						self.data.marks[6] = self.data.marks[6] + 1
						self.data.currentnotes[j][1] = 4
					end
				end
				
				if self.data.currentnotes[j][3] + offset < scroll - self.data.od[#self.data.od - 1] then
					self.data.combo = 0
					self.data.marks[6] = self.data.marks[6] + 1
					self.data.currentnotes[j] = {}
				end
				
				if self.data.currentnotes[j][1] == 2 then
					update(j)
					local lnscale = (self.data.currentnotes[j][3] - self.data.currentnotes[j][2])/drawable.slider:getHeight() * speed
					
					lg.draw(drawable.slider, x, self.data.height - hitPosition - offset * speed - (self.data.currentnotes[j][3] - scroll) * speed, 0, scale.x, lnscale)
					lg.draw(drawable.note, x, self.data.height - hitPosition - offset * speed - (self.data.currentnotes[j][2] - scroll) * speed - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
					lg.draw(drawable.note, x, self.data.height - hitPosition - offset * speed - (self.data.currentnotes[j][3] - scroll) * speed - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
				end
			end
			if self.data.currentnotes[j][1] == 3 then
				
				if self.data.keylocks[j] == 0 and math.abs(self.data.currentnotes[j][3] + offset - self.data.scroll) > self.data.od[#self.data.od - 1] then
					self.data.combo = 0
					self.data.marks[6] = self.data.marks[6] + 1
					self.data.currentnotes[j][1] = 4
				end
				
				if self.data.keylocks[j] == 0 and math.abs(self.data.currentnotes[j][3] + offset - self.data.scroll) <= self.data.od[#self.data.od - 1] then
					self:hit(self.data.currentnotes[j][3] - self.data.scroll, j, 1)
					--self.data.currentnotes[j][1] = 0
				end
				
				if self.data.keylocks[j] == 1 and self.data.currentnotes[j][3] + offset - self.data.scroll <= -1 * self.data.od[#self.data.od - 3] then
					self:hit(self.data.currentnotes[j][3] - self.data.scroll, j, 1)
					--self.data.currentnotes[j][1] = 0
				end
				
				if self.data.currentnotes[j][1] == 3 then
					update(j)
					if self.data.currentnotes[j][2] + offset <= scroll and self.data.currentnotes[j][3] + offset > scroll then
						local lnscale = (self.data.currentnotes[j][3] + offset - scroll)/drawable.slider:getHeight() * speed
						lg.draw(drawable.slider, x, self.data.height - hitPosition - offset * speed - (self.data.currentnotes[j][3] - scroll) * speed, 0, scale.x, lnscale)
						lg.draw(drawable.note, x, self.data.height - hitPosition - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
						lg.draw(drawable.note, x, self.data.height - hitPosition - offset * speed - (self.data.currentnotes[j][3] - scroll) * speed - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
						self.data.currentnotes[j][2] = scroll - offset
					elseif self.data.currentnotes[j][2] + offset <= scroll and self.data.currentnotes[j][3] + offset <= scroll then
					elseif self.data.currentnotes[j][2] + offset > scroll then
						local lnscale = (self.data.currentnotes[j][3] - self.data.currentnotes[j][2])/drawable.slider:getHeight() * speed
						lg.draw(drawable.slider, x, self.data.height - hitPosition - offset * speed - (self.data.currentnotes[j][3] - scroll) * speed, 0, scale.x, lnscale)
						lg.draw(drawable.note, x, self.data.height - hitPosition - offset * speed - (self.data.currentnotes[j][2] - scroll) * speed - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
						lg.draw(drawable.note, x, self.data.height - hitPosition - offset * speed - (self.data.currentnotes[j][3] - scroll) * speed - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
					end
				end
			end
			if self.data.currentnotes[j][1] == 4 then
			
				if self.data.keylocks[j] == 0 and math.abs(self.data.currentnotes[j][3] + offset - self.data.scroll) > self.data.od[#self.data.od - 1] then
					self.data.combo = 0
				end
				
				if self.data.keylocks[j] == 0 and self.data.currentnotes[j][3] + offset - self.data.scroll <= -1 * self.data.od[#self.data.od - 1] then
					self.data.marks[5] = self.data.marks[5] + 1
					if beatmap.HitObjects[self.data.currentnotes[j][2]] == nil then beatmap.HitObjects[self.data.currentnotes[j][2]] = {} end
					beatmap.HitObjects[self.data.currentnotes[j][2]][j] =  {2, self.data.currentnotes[j][2], self.data.currentnotes[j][3], self.data.currentnotes[j][4]}
					self.data.currentnotes[j] = {}
				end
				
				if self.data.currentnotes[j][1] == 4 then
					if self.data.currentnotes[j][3] + offset < scroll - self.data.od[#self.data.od - 1] - hitPosition then
						self.data.currentnotes[j] = {}
					end
				end 
				
				if self.data.currentnotes[j][1] == 4 then
					update(j)
					local lnscale = (self.data.currentnotes[j][3] - self.data.currentnotes[j][2])/drawable.slider:getHeight() * speed
					lg.draw(drawable.slider, x, self.data.height - hitPosition - offset * speed - (self.data.currentnotes[j][3] - scroll) * speed, 0, scale.x, lnscale)
					lg.draw(drawable.note, x, self.data.height - hitPosition - offset * speed - (self.data.currentnotes[j][2] - scroll) * speed - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
					lg.draw(drawable.note, x, self.data.height - hitPosition - offset * speed - (self.data.currentnotes[j][3] - scroll) * speed - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
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
		lg.rectangle("fill", globalscale * x + ColumnLineWidth[1], 0, globalscale * ColumnWidth[i], self.data.height)
		colourLine = skin.config.ColourColumnLine
		lg.setColor(colourLine[1],
								colourLine[2],
								colourLine[3],
								colourLine[4])
		lg.rectangle("fill", globalscale * (x - ColumnLineWidth[1]) + ColumnLineWidth[1], 0, globalscale * ColumnLineWidth[i], self.data.height)
	end
	lg.rectangle("fill", globalscale * (coveerWidth - ColumnLineWidth[1]) + ColumnLineWidth[1] + skin.config.ColumnStart[keymode], 0, globalscale * ColumnLineWidth[#ColumnLineWidth], self.data.height)
	

	lg.setColor(255, 255, 255, 192)
	--lg.draw(skin.sprites.maniaStageLeft, ColumnLineWidth[1] + skin.config.ColumnStart[keymode] - skin.sprites.maniaStageLeft:getWidth(), 0, 0)
	--lg.draw(skin.sprites.maniaStageRight, globalscale * coveerWidth + ColumnLineWidth[1] + skin.config.ColumnStart[keymode], 0, 0)
	--lg.draw(skin.sprites.scorebarBG, globalscale * coveerWidth + 2, self.data.height, -math.pi/2, 0.7, 0.7)
	--lg.draw(skin.sprites.scorebarColour, globalscale * coveerWidth + 3 + 0.7*(skin.sprites.scorebarBG:getWidth() - skin.sprites.scorebarColour:getWidth()), self.data.height - 5, -math.pi/2, 0.7, 0.7)
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

end

function osuClass.convertBeatmap(self)
	beatmap = self.data.beatmap
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
			beatmap.HitObjects.firstnote = tonumber(explode(",", beatmap.raw.array[globalLine + 1])[3])
			for offset = globalLine + 1, #beatmap.raw.array do
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
				beatmap.HitObjectsCount = beatmap.HitObjectsCount + 1
				
				--if string.find(beatmap.raw.array[offset], "[", 1, true) then
				--	break
				--end
			end
		end
	end
end

function osuClass.loadBeatmap(self, cache)
	self.data.beatmap = {}
	beatmap = self.data.beatmap
	beatmap.path = cache.path
	beatmap.pathFile = cache.pathFile
	beatmap.pathAudio = cache.pathAudio
	beatmap.title = cache.title
	beatmap.artist = cache.artist
	beatmap.difficulity = cache.difficulity
	beatmap.audio = love.audio.newSource(cache.pathAudio)
	
	self:convertBeatmap()
end

function osuClass.reloadBeatmap(self)
	data.beatmap = {}
	data.currentnotes = {{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{}}
	data.marks = {0,0,0,0,0,0}
	data.combo = 0
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
		end
		table.insert(cache, {
			title = title,
			artist = artist,
			difficulity = difficulity,
			audio = audio,
			pathAudio = "res/Songs/" .. info[1] .. "/" .. audio,
			pathFile = "res/Songs/" .. info[1] .. "/" .. info[2],
			path = "res/Songs/" .. info[1]
			})
	end
end



