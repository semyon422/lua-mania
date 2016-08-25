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
	self.hitSoundsRules = {
		formats = {"wav", "mp3", "ogg"},
		paths = {
			self.map:get("mapPath"),
			"res/skin/game/hitSounds"
		},
		default = "res/blank.ogg"
	}
	
	for eventSampleIndex, eventSample in pairs(self.map.eventSamples) do
		if not self.hitSounds[eventSample.fileName] then
			local filePath = helpers.getFilePath(eventSample.fileName, self.hitSoundsRules)
			self.hitSounds[eventSample.fileName] = love.audio.newSource(filePath)
		end
	end
	if #self.map.eventSamples > 0 then
		self.currentEventSampleIndex = 1
		self.currentEventSample = self.map.eventSamples[self.currentEventSampleIndex]
	end
	
	self.columns = {}
	for key = 1, self.map:get("CircleSize") do
		self.columns["column" .. key] = self.Column:new({
			name = "column" .. key,
			key = key,
			map = self.map,
			vsrg = self,
			insert = {table = self.columns, onCreate = true}
		})
	end
	if self.map:get("AudioFilename") ~= "virtual" then
		self.map.audio = love.audio.newSource(self.map:get("mapPath") .. "/" .. self.map:get("AudioFilename"))
	end
	self.map.audioStartTime = love.timer.getTime()*1000 + 1000
	self.map.audioState = -1
end

vsrg.postUpdate = function(self)
	if self.map.audioState == -1 then
		self.map.currentTime = math.floor(love.timer.getTime()*1000 - self.map.audioStartTime)
		if self.map.currentTime >= 0 then
			self.map.audioState = 1
			if self.map.audio then
				self.map.audio:play()
			end
		end
	elseif self.map.audioState == 1 then
		if self.map.audio then
			self.map.currentTime = self.map.audio:tell() * 1000
		else
			self.map.currentTime = math.floor(love.timer.getTime()*1000 - self.map.audioStartTime)
		end
	-- elseif self.map.audioState == 2 then
		-- self.map.audioStartTime = math.floor(love.timer.getTime() * 1000 - self.map.currentTime)
	end
	if #self.map.eventSamples > 0 then
		while true do
			if self.currentEventSample.startTime <= self.map.currentTime then
				if self.hitSounds[self.currentEventSample.fileName] then
					local eventSample = self.hitSounds[self.currentEventSample.fileName]:clone()
					eventSample:setVolume(self.currentEventSample.volume)
					eventSample:setPitch(1)
					eventSample:play()
				end
				self.currentEventSampleIndex = self.currentEventSampleIndex + 1
				self.currentEventSample = self.map.eventSamples[self.currentEventSampleIndex]
			else
				break
			end
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
	self.comboCounter:remove()
	if self.map.audio then
		self.map.audio:stop()
	end
	if self.insert then self.insert.table[self.name] = nil end
end

return vsrg
--------------------------------
end

return init