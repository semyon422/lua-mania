game.vsrg = {}
local vsrg = game.vsrg

require("game.vsrg.Layer")
require("game.vsrg.Column")

vsrg.soulObject = soul.SoulObject:new()

vsrg.soulObject.load = function(self)
	vsrg:load()
end

vsrg.soulObject.update = function(self)
	vsrg:update()
end

vsrg.soulObject.unload = function(self)
	vsrg:unload()
end

vsrg.load = function(self)
	self:loadNoteChart()
	self:loadLayers()
end

vsrg.update = function(self)
	self:updateLayers()
end

vsrg.unload = function(self)
	self:unloadLayers()
end

vsrg.loadLayers = function(self)
	self.layers = {}
	for index in pairs(self.noteChart.layers) do
		self.layers[index] = self.Layer:new({
			index = index
		})
		self.layers[index]:load()
	end
end

vsrg.updateLayers = function(self)
	for _, layer in pairs(self.layers) do
		layer:update()
	end
end

vsrg.unloadLayers = function(self)
	for _, layer in pairs(self.layers) do
		layer:unload()
	end
	self.layers = nil
end

vsrg.passEdge = 128
vsrg.missEdge = 160
vsrg.getTimeState = function(self, deltaTime)
	if math.abs(deltaTime) - self.passEdge > 0 and math.abs(deltaTime) - self.missEdge <= 0 then
		if deltaTime > 0 then
			return "early"
		else
			return "late"
		end
	else
		return "exactly"
	end
end

vsrg.judgeScores = {
	{16, 1.1},
	{64, 1.0},
	{96, 0.5},
	{128, 0.25},
	{160, 0}
}
vsrg.getJudgeScore = function(self, deltaTime)
	for _, data in ipairs(self.judgeScores) do
		if math.abs(deltaTime) <= data[1] then
			return data[2]
		end
	end
end

vsrg.setNoteCHart = function(self, noteChart)
	self.noteChart = noteChart
end

vsrg.setSkin = function(self, noteSkin)
	self.noteSkin = noteSkin
end

vsrg.updatePlayData = function(self, playData)
	if playData then
		self.playData = playData
	else
		self.playData = {
			score = 0,
			combo = 0
		}
	end
end

vsrg.loadNoteChart = function(self)
	-- self:loadTimingData()
	-- self:loadEventData()
	-- self:loadNoteData()
	-- self:loadSamples()
end

vsrg.processEventData = function(self)
	-- self.eventData = {}
	-- for name, event in pairs(self.noteCHart.eventData) do
		-- if not self.eventData[name] then
			-- if event.type == "play" do
				-- self.eventData[name] = self:processPlayEvent(event)
			-- end
		-- end
	-- end
end