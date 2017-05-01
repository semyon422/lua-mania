local VSRG = {}

VSRG.new = function(self)
	local vsrg = {}
	
	self.__index = self
	setmetatable(vsrg, self)
	
	return vsrg
end

VSRG.setNoteCHart = function(self, noteChart)
	self.noteChart = noteChart
end

VSRG.setSkin = function(self, skin)
	self.skin = skin
end

VSRG.updatePlayData = function(self, playData)
	if playData then
		self.playData = playData
	else
		self.playData = {
			score = 0,
			combo = 0
		}
	end
end

VSRG.loadNoteChart = function(self)
	self:loadTimingData()
	self:loadEventData()
	self:loadNoteData()
	self:loadSamples()
end

VSRG.processEventData = function(self)
	self.eventData = {}
	for name, event in pairs(self.noteCHart.eventData) do
		if not self.eventData[name] then
			if event.type == "play" do
				self.eventData[name] = self:processPlayEvent(event)
			end
		end
	end
end

VSRG.loadLayers = function(self)
	self.layers = {}
	for _, layer in ipairs(self.noteChart.layers) do
		table.insert(self.layers, self.Layer:new(layer))
	end
end
VSRG.unloadLayers = function(self)
	for _, layer in ipairs(self.layers) do
		layer:unload()
	end
end
VSRG.updateLayers = function(self)
	for _, layer in ipairs(self.layers) do
		layer:update()
	end
end

VSRG.load = function(self)
	self:loadNoteChart()
	self:loadCallbacks()
	self:loadPlayField()
	
	self:loadLayers()
	
	self:updatePlayData()
end

VSRG.update = function(self)
	self:updateAudioState()
	self:updateTiming()
	self:updateLayers()
end

VSRG.remove = function(self)
	self:unloadLayers()
	self:unloadCallbacks()
end

return VSRG
