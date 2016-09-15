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
		name = "comboCounter",
		value = self.combo,
		getValue = function() return self.combo end,
		insert = self.insert
	})
	
	self.speed = luaMania.config["game.vsrg.speed"].value
	
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
			local sourceType = luaMania.config["game.vsrg.hitSoundSourceType"].value
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
	
	loveio.input.callbacks.keypressed.newGame = function(key)
		if key == "f1" then
			self.map.audioState = "paused"
		elseif key == "f2" then
			self.map.audioState = "started"
		end
	end
	
	self.columns = {}
	for key = 1, self.map.keymode do
		self.columns["column" .. key] = self.Column:new({
			name = "column" .. key,
			key = key,
			map = self.map,
			vsrg = self,
			insert = {table = self.columns, onCreate = true}
		})
	end
	
	self.audioPitch = luaMania.config["game.vsrg.audioPitch"].value
	if self.map.audioFilename ~= "virtual" then
		local sourceType = luaMania.config["game.vsrg.audioSourceType"].value
		self.map.audio = love.audio.newSource(self.map.mapPath .. "/" .. self.map.audioFilename, sourceType)
		self.map.audio2 = love.audio.newSource(self.map.mapPath .. "/" .. self.map.audioFilename, sourceType)
	else
		local lastHitObject = self.map.hitObjects[#self.map.hitObjects]
		local samples = 44100 * (lastHitObject.endTime and lastHitObject.endTime or lastHitObject.startTime) / 1000
		local soundData = love.sound.newSoundData(samples)
		self.map.audio = love.audio.newSource(soundData)
	end
	self.map.audio:setPitch(self.audioPitch)
	self.map.audioStartTime = love.timer.getTime()*1000 + 1000
	self.map.audioState = "delayed"
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
	
	self.map.currentTime = self.map.currentTime + luaMania.config["game.vsrg.offset"].value
	if #self.map.eventSamples > 0 then
		while true do
			if self.currentEventSample and self.currentEventSample.startTime <= self.map.currentTime then
				if self.hitSounds[self.currentEventSample.fileName] then
					local eventSample = self.hitSounds[self.currentEventSample.fileName]:clone()
					eventSample:setVolume(self.currentEventSample.volume or 1)
					eventSample:setPitch(self.audioPitch)
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
	if self.insert then self.insert.table[self.name] = nil end
end

return vsrg
--------------------------------
end

return init