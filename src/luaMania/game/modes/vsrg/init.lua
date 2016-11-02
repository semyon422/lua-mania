local init = function(game, luaMania)
--------------------------------
local vsrg = loveio.LoveioObject:new()

vsrg.map = {}

vsrg.path = game.path .. "modes/vsrg/"

vsrg.HitObject = require(vsrg.path .. "HitObject")(vsrg, game, luaMania)
vsrg.Note = require(vsrg.path .. "Note")(vsrg, game, luaMania)
vsrg.Hold = require(vsrg.path .. "Hold")(vsrg, game, luaMania)
vsrg.Column = require(vsrg.path .. "Column")(vsrg, game, luaMania)

vsrg.load = function(self)
	self.columns = {}
	self.createdObjects = {}
	self.combo = 0
	self.comboCounter = ui.classes.Button:new({
		x = 0.15, y = 0.45, w = 0.1, h = 0.1,
		value = self.combo,
		getValue = function() return self.combo end
	}):insert(loveio.objects)
	if self.map.backgroundPath then
		luaMania.ui.menuBackground.prevValue = luaMania.ui.menuBackground.value
		luaMania.ui.menuBackground.value = self.map.backgroundPath
		luaMania.ui.menuBackground:reload()
		self.backgroundChanged = true
	end
	
	self.hitSounds = {}
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
			local sourceType = luaMania.config["game.vsrg.hitSoundSourceType"]:get()
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
	
	self.currentTimingPoint = self.map.timingPoints[1]
	
	self.keyBindPlay = luaMania.config["keyBind.game.vsrg.play"]:get()
	self.keyBindPause = luaMania.config["keyBind.game.vsrg.pause"]:get()
	self.keyBindSpeedUp = luaMania.config["keyBind.game.vsrg.speedUp"]:get()
	self.keyBindSpeedDown = luaMania.config["keyBind.game.vsrg.speedDown"]:get()
	self.keyBindOffsetUp = luaMania.config["keyBind.game.vsrg.offsetUp"]:get()
	self.keyBindOffsetDown = luaMania.config["keyBind.game.vsrg.offsetDown"]:get()
	self.keyBindVelocityPowerUp = luaMania.config["keyBind.game.vsrg.velocityPowerUp"]:get()
	self.keyBindVelocityPowerDown = luaMania.config["keyBind.game.vsrg.velocityPowerDown"]:get()
	self.keyBindAudioPitchUp = luaMania.config["keyBind.game.vsrg.audioPitchUp"]:get()
	self.keyBindAudioPitchDown = luaMania.config["keyBind.game.vsrg.audioPitchDown"]:get()
	loveio.input.callbacks.keypressed.newGame = function(key)
		if key == self.keyBindPause then
			self.map.audioState = "paused"
		elseif key == self.keyBindPlay then
			self.map.audioState = "started"
		elseif key == self.keyBindSpeedUp then
			local newValue = luaMania.config["game.vsrg.speed"]:get() + 0.1
			luaMania.config["game.vsrg.speed"]:set(newValue)
			print("speed = " .. newValue)
		elseif key == self.keyBindSpeedDown then
			local newValue = luaMania.config["game.vsrg.speed"]:get() - 0.1
			if newValue >= 0.1 then
				luaMania.config["game.vsrg.speed"]:set(newValue)
				print("speed = " .. newValue)
			end
		elseif key == self.keyBindOffsetUp then
			local newValue = luaMania.config["game.vsrg.offset"]:get() + 1
			luaMania.config["game.vsrg.offset"]:set(newValue)
		elseif key == self.keyBindOffsetDown then
			local newValue = luaMania.config["game.vsrg.offset"]:get() - 1
			luaMania.config["game.vsrg.offset"]:set(newValue)
		elseif key == self.keyBindVelocityPowerUp then
			local newValue = luaMania.config["game.vsrg.velocityPower"]:get() + 0.1
			luaMania.config["game.vsrg.velocityPower"]:set(newValue)
			print("velocityPower = " .. newValue)
		elseif key == self.keyBindVelocityPowerDown then
			local newValue = luaMania.config["game.vsrg.velocityPower"]:get() + 0.1
			if newValue >= 0.1 then
				luaMania.config["game.vsrg.velocityPower"]:set(newValue)
				print("velocityPower = " .. newValue)
			end
		elseif key == self.keyBindAudioPitchUp then
			local newValue = luaMania.config["game.vsrg.audioPitch"]:get() + 0.1
			luaMania.config["game.vsrg.audioPitch"]:set(newValue)
			self.map.audio:setPitch(newValue)
			for _, sample in pairs(self.playingHitSounds) do
				sample:setPitch(newValue)
			end
			print("audioPitch = " .. newValue)
		elseif key == self.keyBindAudioPitchDown then
			local newValue = luaMania.config["game.vsrg.audioPitch"]:get() - 0.1
			if newValue >= 0.1 then
				luaMania.config["game.vsrg.audioPitch"]:set(newValue)
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
	
	if self.map.audioFilename ~= "virtual" then
		local sourceType = luaMania.config["game.vsrg.audioSourceType"]:get()
		self.map.audio = love.audio.newSource(self.map.mapPath .. "/" .. self.map.audioFilename, sourceType)
	else
		local lastHitObject = self.map.hitObjects[#self.map.hitObjects]
		local samples = 44100 * ((lastHitObject.endTime and lastHitObject.endTime or lastHitObject.startTime) / 1000 + 2)
		local soundData = love.sound.newSoundData(samples)
		self.map.audio = love.audio.newSource(soundData)
	end
	self.map.audio:setPitch(luaMania.config["game.vsrg.audioPitch"]:get())
	self.map.audioStartTime = love.timer.getTime()*1000 + 1000
	self.map.audioState = "delayed"
	self.map.currentTime = -1000
	for _, column in pairs(self.columns) do
		if column.update then column:update() end
	end
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
	
	self.map.currentTime = self.map.currentTime + luaMania.config["game.vsrg.offset"]:get()
	if #self.map.eventSamples > 0 then
		local audioPitch = luaMania.config["game.vsrg.audioPitch"]:get()
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
		luaMania.ui.menuBackground.value = luaMania.ui.menuBackground.prevValue
		luaMania.ui.menuBackground.prevValue = nil
		luaMania.ui.menuBackground:reload()
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