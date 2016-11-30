local init = function(game)
--------------------------------
local vsrg = loveio.LoveioObject:new()

vsrg.defaultKeyBinds = {
	[4] = {"d", "f", "j", "k"},
	[5] = {"d", "f", "space", "j", "k"},
	[6] = {"s", "d", "f", "j", "k", "l"},
	[7] = {"s", "d", "f", "space", "j", "k", "l"},
	[8] = {"a", "s", "d", "f", "j", "k", "l", ";"},
	[9] = {"a", "s", "d", "f", "space", "j", "k", "l", ";"}
}

vsrg.map = {}

vsrg.skin = require("res/defaultSkin")()
vsrg.path = game.path .. "modes/vsrg/"

vsrg.HitObject = require(vsrg.path .. "HitObject")(vsrg, game)
vsrg.Note = require(vsrg.path .. "Note")(vsrg, game)
vsrg.Hold = require(vsrg.path .. "Hold")(vsrg, game)
vsrg.Column = require(vsrg.path .. "Column")(vsrg, game)

vsrg.load = function(self)
	self.columns = {}
	self.createdObjects = {}
	self.combo = 0
	self.comboCounter = ui.classes.Button:new({
		x = 0, y = 0.5 - self.skin.game.vsrg.columnStart / 2, w = self.skin.game.vsrg.columnStart, h = self.skin.game.vsrg.columnStart,
		value = self.combo, backgroundColor = {0, 0, 0, 191},
		getValue = function() return self.combo end,
		layer = 20
	}):insert(loveio.objects)
	self.pitchDisplay = ui.classes.Button:new({
		x = 0, y = 0.25 - self.skin.game.vsrg.columnStart / 2, w = self.skin.game.vsrg.columnStart, h = self.skin.game.vsrg.columnStart,
		value = "x" .. mainConfig:get("game.vsrg.audioPitch", 1), backgroundColor = {0, 0, 0, 191},
		getValue = function() return "x" .. mainConfig:get("game.vsrg.audioPitch", 1) end,
		layer = 20
	}):insert(loveio.objects)
	
	if mainConfig:get("enableBackground", 1) == 0 then
		uiBase.background:unload()
	elseif self.map.backgroundPath and love.filesystem.exists(self.map.backgroundPath) and love.filesystem.isFile(self.map.backgroundPath) then
		uiBase.background.prevPath = uiBase.background.path
		uiBase.background.path = self.map.backgroundPath
		uiBase.background:reload()
		self.backgroundChanged = true
	end
	
	self.hitSounds = {}
	self.wrongHitSounds = {}
	self.playingHitSounds = {}
	self.hitSoundsRules = {
		formats = {"wav", "mp3", "ogg"},
		paths = {
			self.map.mapPath,
			"res/hitSounds"
		}
	}
	
	for eventSampleIndex, eventSample in pairs(self.map.eventSamples) do
		if not self.hitSounds[eventSample.fileName] then
			local filePath = helpers.getFilePath(eventSample.fileName, self.hitSoundsRules)
			local sourceType =  mainConfig:get("game.vsrg.hitSoundSourceType", "static")
			if not filePath then
				self.hitSounds[eventSample.fileName] = love.audio.newSource(love.sound.newSoundData(1))
			else
				self.hitSounds[eventSample.fileName] = love.audio.newSource(filePath, sourceType)
			end
		end
	end
	if #self.map.eventSamples > 0 then
		self.currentEventSampleIndex = 1
		self.currentEventSample = self.map.eventSamples[self.currentEventSampleIndex]
	end
	for hitObjectIndex, hitObject in ipairs(self.map.hitObjects) do
		for hitSoundIndex, hitSoundName in pairs(hitObject.hitSoundsList) do
			if not self.hitSounds[hitSoundName] then
				local filePath = helpers.getFilePath(hitSoundName, self.hitSoundsRules)
				local sourceType = mainConfig:get("game.vsrg.hitSoundSourceType", "static")
				if not filePath then
					self.hitSounds[hitSoundName] = love.audio.newSource(love.sound.newSoundData(1))
				else
					local status, value = pcall(love.audio.newSource, filePath, sourceType)
					if status then
						self.hitSounds[hitSoundName] = value
					elseif not self.vsrg.wrongHitSounds[hitSoundName] then
						self.hitSounds[hitSoundName] = love.audio.newSource(love.sound.newSoundData(1))
						self.wrongHitSounds[hitSoundName] = true
						print("Can't load hitsound: " .. filePath .. "(" .. value .. ")")
					end
				end
			end
		end
	end
	
	self.currentTimingPoint = self.map.timingPoints[1]
	
	self.keyBindSpeedUp = mainConfig:get("keyBind.game.vsrg.speedUp", "")
	self.keyBindSpeedDown = mainConfig:get("keyBind.game.vsrg.speedDown", "")
	self.keyBindOffsetUp = mainConfig:get("keyBind.game.vsrg.offsetUp", "")
	self.keyBindOffsetDown = mainConfig:get("keyBind.game.vsrg.offsetDown", "")
	self.keyBindVelocityPowerUp = mainConfig:get("keyBind.game.vsrg.velocityPowerUp", "")
	self.keyBindVelocityPowerDown = mainConfig:get("keyBind.game.vsrg.velocityPowerDown", "")
	self.keyBindAudioPitchUp = mainConfig:get("keyBind.game.vsrg.audioPitchUp", "")
	self.keyBindAudioPitchDown = mainConfig:get("keyBind.game.vsrg.audioPitchDown", "")
	loveio.input.callbacks.keypressed.newGame = function(key)
		if key == "escape" then
			if love.keyboard.isDown("lshift") then
				mainCli:run("gameState set mapList")
			else
				if self.map.audioState == "paused" then
					self.map.audioState = "started"
				elseif self.map.audioState == "started" then
					self.map.audioState = "paused"
				end
			end
		elseif key == self.keyBindSpeedUp then
			local newValue = mainConfig:get("game.vsrg.speed", 1) + 0.1
			mainConfig:set("game.vsrg.speed", newValue)
			print("speed = " .. newValue)
		elseif key == self.keyBindSpeedDown then
			local newValue = mainConfig:get("game.vsrg.speed", 1) - 0.1
			if newValue >= 0.1 then
				mainConfig:set("game.vsrg.speed", newValue)
				print("speed = " .. newValue)
			end
		elseif key == self.keyBindOffsetUp then
			local newValue = mainConfig:get("game.vsrg.offset", 0) + 1
			mainConfig:set("game.vsrg.offset", newValue)
		elseif key == self.keyBindOffsetDown then
			local newValue = mainConfig:get("game.vsrg.offset", 0) - 1
			mainConfig:set("game.vsrg.offset", newValue)
		elseif key == self.keyBindVelocityPowerUp then
			local newValue = mainConfig:get("game.vsrg.velocityPower", 1) + 0.1
			mainConfig:set("game.vsrg.velocityPower", newValue)
			print("velocityPower = " .. newValue)
		elseif key == self.keyBindVelocityPowerDown then
			local newValue = mainConfig:get("game.vsrg.velocityPower", 1) - 0.1
			if newValue >= 0.1 then
				mainConfig:set("game.vsrg.velocityPower", newValue)
				print("velocityPower = " .. newValue)
			end
		elseif key == self.keyBindAudioPitchUp then
			local newValue = mainConfig:get("game.vsrg.audioPitch", 1) + 0.1
			mainConfig:set("game.vsrg.audioPitch", newValue)
			self.map.audio:setPitch(newValue)
			for _, sample in pairs(self.playingHitSounds) do
				sample:setPitch(newValue)
			end
			print("audioPitch = " .. newValue)
		elseif key == self.keyBindAudioPitchDown then
			local newValue = mainConfig:get("game.vsrg.audioPitch", 1) - 0.1
			if newValue >= 0.1 then
				mainConfig:set("game.vsrg.audioPitch", newValue)
				self.map.audio:setPitch(newValue)
				for _, sample in pairs(self.playingHitSounds) do
					sample:setPitch(newValue)
				end
				print("audioPitch = " .. newValue)
			end
		end
	end
	
	self.columns = {}
	for key = 1, self.map.keymode do
		self.columns["column" .. key] = self.Column:new({
			name = "column" .. key,
			key = key,
			map = self.map,
			vsrg = self
		}):insert(self.columns)
	end
	
	self.map.audio:setPitch(mainConfig:get("game.vsrg.audioPitch", 1))
	self.map.audioStartTime = love.timer.getTime()*1000 + 1000
	self.map.audioState = "delayed"
	self.map.currentTime = -1000
end

vsrg.postUpdate = function(self)
	if self.map.audioState == "delayed" then
		self.map.currentTime = math.floor(love.timer.getTime()*1000 - self.map.audioStartTime)
		if self.map.currentTime > 0 then
			self.map.audioState = "started"
			self.map.audio:play()
		end
	elseif self.map.audioState == "started" then
		if not self.map.audio:isPlaying() then self.map.audio:play() end
		self.map.currentTime = math.floor(self.map.audio:tell() * 1000)
		if self.map.audio:isStopped() then
			self.map.audioState = "ended"
			self.map.audioStartTime = love.timer.getTime() * 1000
		end
	elseif self.map.audioState == "ended" then
		self.map.currentTime = math.floor(love.timer.getTime()*1000 - self.map.audioStartTime)
	elseif self.map.audioState == "paused" then
		self.map.audioStartTime = love.timer.getTime()*1000
		if not self.map.audio:isPaused() then self.map.audio:pause() end
	end
	
	self.map.currentTime = math.floor(self.map.currentTime + mainConfig:get("game.vsrg.offset", 1))
	if #self.map.eventSamples > 0 then
		local audioPitch = mainConfig:get("game.vsrg.audioPitch", 1)
		while true do
			if self.currentEventSample and self.currentEventSample.startTime <= self.map.currentTime then
				if self.hitSounds[self.currentEventSample.fileName] then
					local eventSample = self.hitSounds[self.currentEventSample.fileName]:clone()
					eventSample:setVolume(self.currentEventSample.volume or 1)
					eventSample:setPitch(audioPitch)
					eventSample:play()
					table.insert(self.playingHitSounds, eventSample)
				end
				self.currentEventSampleIndex = self.currentEventSampleIndex + 1
				self.currentEventSample = self.map.eventSamples[self.currentEventSampleIndex]
			else
				break
			end
		end
	end
	while true do
		if self.currentTimingPoint.endTime <= self.map.currentTime then
			if self.map.timingPoints[self.currentTimingPoint.index + 1] then
				self.currentTimingPoint = self.map.timingPoints[self.currentTimingPoint.index + 1]
			else
				break
			end
		else
			break
		end
	end
	for hitSoundIndex, hitSound in pairs(self.playingHitSounds) do
		if hitSound:isStopped() then
			self.playingHitSounds[hitSoundIndex] = nil
		end
	end
	for _, column in pairs(self.columns) do
		if column.update then column:update() end
	end
end

vsrg.unload = function(self)
	if self.backgroundChanged then
		uiBase.background.path = uiBase.background.prevPath
		uiBase.background.prevPath = nil
		uiBase.background:reload()
		self.backgroundChanged = false
	end
	if self.columns then
		for columnIndex, column in pairs(self.columns) do
			column:remove()
		end
	end
	self.columns = nil
	if self.createdObjects then
		for createdObjectIndex, createdObject in pairs(self.createdObjects) do
			createdObject:remove()
		end
	end
	self.comboCounter:remove()
	self.pitchDisplay:remove()
	self.map.audio:stop()
	for hitSoundIndex, hitSound in pairs(self.playingHitSounds) do
		hitSound:stop()
		self.playingHitSounds[hitSoundIndex] = nil
	end
	loveio.input.callbacks.keypressed.newGame = nil
end

return vsrg
--------------------------------
end

return init
