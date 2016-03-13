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

osuClass.printDebugInfo = require "src.functions.printDebugInfo"

function osuClass.hit(self, ms, key)
	local trueMs = ms + data.config.offset
	local beatmap = data.beatmap
	local currentTime = data.stats.currentTime
	local offset = data.config.offset
	if data.beatmap.objects.current[key].type[1] == 2 and data.beatmap.objects.current[key].type[2] == 2 and data.beatmap.objects.current[key].startTime + offset <= currentTime + data.od[#data.od] and data.beatmap.objects.current[key].startTime + offset > currentTime - data.od[#data.od - 1] then
	
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
	if data.beatmap.objects.current[key].type[1] == 2 then
		if data.beatmap.objects.current[key].startTime < data.stats.currentTime - data.od[#data.od - 1] and data.beatmap.objects.current[key].endTime > data.stats.currentTime + data.od[#data.od - 1] then
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
	
	if data.stats.x ~= nil and love.keyboard.isDown("left") then
		data.stats.x = data.stats.x - 750*data.dt
	end
	if data.stats.x ~= nil and love.keyboard.isDown("right") then
		data.stats.x = data.stats.x + 750*data.dt
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
						self:hit(data.beatmap.objects.current[keynumber].startTime - data.stats.currentTime, keynumber)
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
			data.stats.currentTime = math.floor(lt.getTime() * 1000 - data.startstartTime)
			if data.stats.currentTime >= 0 then
				data.play = 1
				data.beatmap.audio:play()
			end
		elseif data.play == 1 then
			data.stats.currentTime =  math.floor(data.beatmap.audio:tell() * 1000)
		elseif data.play == 2 then
			--data.stats.currentTime = math.floor(data.beatmap.audio:tell() * 1000)
			data.startstartTime = math.floor(lt.getTime() * 1000 - data.stats.currentTime)
		end
	else
		if data.play == -1 then
			data.stats.currentTime = math.floor(lt.getTime() * 1000 - data.startstartTime)
			if data.stats.currentTime >= 0 then
				data.play = 1
			end
		elseif data.play == 1 then
			data.stats.currentTime = math.floor(lt.getTime() * 1000 - data.startstartTime)
		elseif data.play == 2 then
			data.startstartTime = math.floor(lt.getTime() * 1000 - data.stats.currentTime)
		end
	end

end

osuClass.removeExtension = require "src.functions.removeExtension"

osuClass.getHitSound = require "src.functions.getHitSound"

osuClass.playHitSound = require "src.functions.playHitSound"

osuClass.drawBackground = require "src.functions.drawBackground"



osuClass.getObjects = require "src.objectsHandlers.mania.getObjects"

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
		},
		colorScheme = {}
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
	
	for index,item in pairs(skin.config.Colours) do
		skin.sprites.colorScheme[index] = {
			NoteImage = lg.newImage(name .. "/" .. skin.config.Colours[index].NoteImage),
			NoteImageL = lg.newImage(name .. "/" .. skin.config.Colours[index].NoteImageL)
		}
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





