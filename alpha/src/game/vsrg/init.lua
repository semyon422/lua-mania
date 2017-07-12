game.VSRG = createClass(soul.SoulObject)
local VSRG = game.VSRG

require("game.VSRG.Layer")
require("game.VSRG.Column")
require("game.VSRG.NoteHandler")

VSRG.load = function(self)
	self:loadNoteChart()
	self:loadLayers()
	self:loadNoteHandlers()
	
	self.loaded = true
end

VSRG.update = function(self)
	self:updateLayers()
end

VSRG.unload = function(self)
	self:unloadLayers()
	
	self.loaded = false
end

VSRG.loadNoteHandlers = function(self)
	self.noteHandlers = {}
	for index in pairs(self.noteChart.columnCount) do
		self.noteHandlers[index] = self.NoteHandler:new({
			columnIndex = index
		})
		self.noteHandlers[index]:load()
	end
end

VSRG.updateNoteHandlers = function(self)
	for _, noteHandler in pairs(self.noteHandlers) do
		noteHandler:update()
	end
end

VSRG.unloadNoteHandlers = function(self)
	for _, noteHandler in pairs(self.noteHandlers) do
		noteHandler:unload()
	end
	self.noteHandlers = nil
end

VSRG.loadLayers = function(self)
	self.layers = {}
	for index in pairs(self.noteChart.layers) do
		self.layers[index] = self.Layer:new({
			index = index
		})
		self.layers[index]:load()
	end
end

VSRG.updateLayers = function(self)
	for _, layer in pairs(self.layers) do
		layer:update()
	end
end

VSRG.unloadLayers = function(self)
	for _, layer in pairs(self.layers) do
		layer:unload()
	end
	self.layers = nil
end

VSRG.passEdge = 128
VSRG.missEdge = 160
VSRG.getTimeState = function(self, deltaTime)
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

VSRG.judgeScores = {
	{16, 1.1},
	{64, 1.0},
	{96, 0.5},
	{128, 0.25},
	{160, 0}
}
VSRG.getJudgeScore = function(self, deltaTime)
	for _, data in ipairs(self.judgeScores) do
		if math.abs(deltaTime) <= data[1] then
			return data[2]
		end
	end
end

VSRG.setNoteCHart = function(self, noteChart)
	self.noteChart = noteChart
end

VSRG.setSkin = function(self, noteSkin)
	self.noteSkin = noteSkin
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
	-- self:loadTimingData()
	-- self:loadEventData()
	-- self:loadNoteData()
	-- self:loadSamples()
end

VSRG.processEventData = function(self)
	-- self.eventData = {}
	-- for name, event in pairs(self.noteCHart.eventData) do
		-- if not self.eventData[name] then
			-- if event.type == "play" do
				-- self.eventData[name] = self:processPlayEvent(event)
			-- end
		-- end
	-- end
end