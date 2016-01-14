--[[
semyon422's tools and games based on love2d - useful tools and game ports
Copyright (C) 2016 Semyon Jolnirov

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
	
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print(
		"FPS: "..love.timer.getFPS().."\n"..
		--"beatmap ms1: "..math.floor(self.data.scroll).."\n"..
		"time: " .. math.ceil(beatmap.audio:tell()*1000)/1000 .. "\n"
	, 0, 0, 0, 1, 1)
	
	love.graphics.setColor(255, 255, 255, 255)
end

function osuClass.drawMenu(self)
	if self.data.menu.state == "onscreen" then
		love.graphics.draw(self.data.menu.sprite, 0, 0, 0, love.graphics.getHeight() / self.data.menu.sprite:getWidth(), love.graphics.getHeight() / self.data.menu.sprite:getHeight())
		love.graphics.draw(self.data.menu.backsprite, 0, love.graphics.getWidth() - self.data.menu.backsprite:getHeight() * (love.graphics.getHeight() / self.data.menu.backsprite:getWidth()), 0, love.graphics.getHeight() / self.data.menu.backsprite:getWidth(), love.graphics.getHeight() / self.data.menu.backsprite:getWidth())
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


function osuClass.keyboard(self)
	local dt = self.data.dt
	local hud = self.data.hud
	local beatmap = self.data.beatmap

	local keyboard = self.data.keyboard

	
	if love.keyboard.isDown(keyboard.key.start) then
		self:start()
	end
	if love.keyboard.isDown(keyboard.key.stop) then
		self:stop()
	end
	if love.keyboard.isDown(keyboard.key.play) then
		self:play()
	end
	if love.keyboard.isDown(keyboard.key.pause) then
		self:pause()
	end
	

	if self.data.play == 1 then
		self.data.scroll = beatmap.audio:tell() * 1000
		--self.data.scroll = love.timer.getTime() * 1000 - self.data.starttime
	elseif self.data.play == 2 then
		self.data.scroll = beatmap.audio:tell() * 1000
		self.data.starttime = love.timer.getTime() * 1000 - self.data.scroll
	end
end


function osuClass.drawBackground(self)
	local background = self.data.skin.sprites.background
	local darkness = self.data.darkness
	local skin = self.data.skin
	
	love.graphics.setBackgroundColor(0, 0, 0)
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

		love.graphics.draw(background, self.data.width / 2, self.data.height / 2, 0, scale, scale, background:getWidth() / 2, background:getHeight() / 2)
		
		love.graphics.setColor(0, 0, 0, (darkness / 100) * 255)
		love.graphics.rectangle("fill", 0, 0, self.data.width, self.data.height)
		love.graphics.setColor(255, 255, 255, 255)
	end

	
end

function osuClass.drawNotes(self)
	local beatmap = self.data.beatmap
	local scroll = self.data.scroll
	local speed = self.data.speed
	local skin = self.data.skin
	local offset = self.data.offset
	local globalscale = self.data.globalscale
	
	keymode = tonumber(beatmap.General["CircleSize"])
	
	ColumnColours = skin.config.ManiaColours[keymode]
	ColumnWidth = skin.config.ColumnWidth[keymode]
	ColumnLineWidth = skin.config.ColumnLineWidth[keymode]
	drawable = {}
	scale = {}
	function update(note)
		drawable.note = skin.sprites.mania.note[ColumnColours[note[1]]]
		drawable.slider = skin.sprites.mania.sustain[ColumnColours[note[1]]]
		scale.x = globalscale * ColumnWidth[note[1]] / drawable.note:getWidth()
		x = ColumnLineWidth[1]
		for j = 1, note[1] - 1 do
			x = x + ColumnWidth[j] + ColumnLineWidth[j + 1]
		end
		x = x * globalscale
	end
	update(beatmap.HitObjects[1])
	scale.y = globalscale * ColumnWidth[1] / drawable.note:getWidth()
	function isslider(note) if note[3] == nil then return false else return true end end
	for i = 1, #beatmap.HitObjects do
		note = beatmap.HitObjects[i]

		onscreen = false
		update(note)
		if (((note[2] - scroll) * speed >= offset.y) and
			((note[2] - scroll) * speed <= self.data.height + offset.y)) then
			love.graphics.draw(drawable.note, offset.x + x, offset.y + self.data.height - (note[2] - scroll) * speed - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
			onscreen = true
		end
		if isslider(note) then
			if (((note[3] - scroll) * speed >= offset.y) and
				((note[3] - scroll) * speed <= self.data.height + offset.y)) then
				love.graphics.draw(drawable.note, offset.x + x, offset.y + self.data.height - (note[3] - scroll) * speed - drawable.note:getHeight()*scale.y, 0, scale.x, scale.y)
				onscreen = true
			end
			if ((((note[3] - scroll) * speed >= self.data.height + offset.y) and
				(((note[2] - scroll) * speed <= offset.y)))) or onscreen then
				love.graphics.draw(drawable.slider, offset.x + x, offset.y + self.data.height - (note[3] - scroll) * speed, 0, scale.x, (note[3] - note[2] - drawable.note:getHeight() * scale.y)/drawable.slider:getHeight() * speed)
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
		x = ColumnLineWidth[1]
		for j = 1, i - 1 do
			x = x + ColumnWidth[j] + ColumnLineWidth[j + 1]
		end
		coveerWidth = coveerWidth + ColumnWidth[i] + ColumnLineWidth[i + 1]
		colourBG = skin.config.Colours[ColumnColours[i]].Colour
		love.graphics.setColor(colourBG[1],
								colourBG[2],
								colourBG[3],
								colourBG[4])
		love.graphics.rectangle("fill", globalscale * x + offset.x, 0, globalscale * ColumnWidth[i], self.data.height)
		colourLine = skin.config.ColourColumnLine
		love.graphics.setColor(colourLine[1],
								colourLine[2],
								colourLine[3],
								colourLine[4])
		love.graphics.rectangle("fill", globalscale * (x - ColumnLineWidth[1]) + offset.x, 0, globalscale * ColumnLineWidth[i], self.data.height)
	end
	love.graphics.rectangle("fill", globalscale * (coveerWidth - ColumnLineWidth[1]) + offset.x, 0, globalscale * ColumnLineWidth[#ColumnLineWidth], self.data.height)
	

	love.graphics.setColor(255, 255, 255, 192)
	love.graphics.draw(skin.sprites.maniaStageLeft, offset.x - skin.sprites.maniaStageLeft:getWidth(), 0, 0)
	love.graphics.draw(skin.sprites.maniaStageRight, globalscale * coveerWidth + offset.x, 0, 0)
	--love.graphics.draw(skin.sprites.scorebarBG, globalscale * coveerWidth + offset.x + 2, self.data.height, -math.pi/2, 0.7, 0.7)
	--love.graphics.draw(skin.sprites.scorebarColour, globalscale * coveerWidth + offset.x + 3 + 0.7*(skin.sprites.scorebarBG:getWidth() - skin.sprites.scorebarColour:getWidth()), self.data.height - 5, -math.pi/2, 0.7, 0.7)
	love.graphics.setColor(255, 255, 255, 255)

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
		skin.sprites.mania.key[i] = love.graphics.newImage(name .. "/" .. skin.config.Colours[i].KeyImage)
	end
	for i = 1, #skin.config.Colours do
		skin.sprites.mania.note[i] = love.graphics.newImage(name .. "/" .. skin.config.Colours[i].NoteImage)
	end
	for i = 1, #skin.config.Colours do
		skin.sprites.mania.sustain[i] = love.graphics.newImage(name .. "/" .. skin.config.Colours[i].NoteImageL)
	end
	skin.sprites.maniaStageRight = love.graphics.newImage(name .. "/mania-stage-right.png")
	skin.sprites.maniaStageLeft = love.graphics.newImage(name .. "/mania-stage-left.png")
	--skin.sprites.scorebarColour = love.graphics.newImage(name .. "/scorebar-colour.png")
	--skin.sprites.scorebarBG = love.graphics.newImage(name .. "/scorebar-bg.png")
	skin.sprites.background = love.graphics.newImage(name .. "/menu-background.png")

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
		#explode("General", beatmap.raw.array[globalLine]) == 2 or
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
		if #explode("HitObjects", beatmap.raw.array[globalLine]) == 2 then
			for offset = globalLine + 1, #beatmap.raw.array - globalLine do
				localLine = offset - globalLine
				beatmap.raw.HitObjects[localLine] = explode(",", beatmap.raw.array[offset])
				beatmap.HitObjects[localLine] = {}
				keys = tonumber(beatmap.General["CircleSize"])
				interval = 512/keys
				beatmap.raw.HitObjects[localLine][1] = tonumber(beatmap.raw.HitObjects[localLine][1])
				for key = 1, keys do
					if beatmap.raw.HitObjects[localLine][1] >= key * interval - interval and beatmap.raw.HitObjects[localLine][1] < key * interval then
						beatmap.HitObjects[localLine][1] = key
					end
				end
				beatmap.HitObjects[localLine][2] = beatmap.raw.HitObjects[localLine][3]
				if beatmap.raw.HitObjects[localLine][4] == "128" then
					beatmap.HitObjects[localLine][3] = explode(":", beatmap.raw.HitObjects[localLine][6])[1]
				end
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
