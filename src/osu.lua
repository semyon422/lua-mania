--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
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
			"speed multiplier: " .. data.stats.speed .. "\n" ..
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

function osuClass.keyboard(self)
	local dt = data.dt
	local hud = data.hud
	local beatmap = data.beatmap

	local keyboard = data.keyboard

	if love.keyboard.isDown("m") then
		data.beatmap.audio:setVolume(0)
	end
	if love.keyboard.isDown("n") then
		data.beatmap.audio:setVolume(1)
	end
	
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
							self:playHitSound(self:getHitSound(data.beatmap.hitSounds[keynumber][1]))
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

osuClass.removeExtension = require "src.functions.removeExtension"

osuClass.getHitSound = require "src.functions.getHitSound"

osuClass.playHitSound = require "src.functions.playHitSound"

osuClass.drawBackground = require "src.functions.drawBackground"

function osuClass.drawObjects(self)
	local objects = data.objects
	
	for layer = 1, #objects do
		for number = 1, #objects[layer] do
			local object = objects[layer][number]
			if object.type == "note" then
				self:drawNote(object.data)
			elseif object.type == "rectangle" then
				self:drawRectangle(object.data)
			end
		end
	end
end

function osuClass.drawNote(self, info)
	--[[
		info = {
			[1] = {color = {255,255,255,255},drawable = noteimage, x = 100, y = 200, r = 0, sx = 1, sy = 1},
		}
	]]
	for i = 1, #info do
		local note = info[i]
		if note.color == nil then note.color = {255, 255, 255, 255} end
		if note.r == nil then note.r = 0 end
		lg.setColor(note.color)
		lg.draw(note.drawable, note.x, note.y, note.r, note.sx, note.sy)
		lg.setColor({255, 255, 255, 255})
	end
end

function osuClass.drawRectangle(self, info)
	if info.type == nil then info.type = "fill" end
	if info.y == nil then info.y = 0 end
	if info.h == nil then info.h = data.height end
	
	lg.setColor(info.color)
	lg.rectangle(info.type, info.x, info.y, info.w, info.h)
end

osuClass.getObjects = require "src.gamemodes.mania.getObjects"

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
	skin.sprites.background = lg.newImage(name .. "/menu-background.png")
	
	skin.sampleSet = {}
end

function osuClass.clearStats(self)
	data.stats.hits = {0,0,0,0,0,0}
	data.stats.combo = 0
	data.stats.maxcombo = 0
	data.stats.speed = nil
	data.stats.objects = {}
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





