game.vsrg.Layer = createClass()
local Layer = game.vsrg.Layer

Layer.getVirtualTime = function(self, time)
	--TODO: rewrite old function
	return time
end

Layer.loadTimingData = function(self)
	self.timingData = {}
	for _, timingPoint in ipairs(game.noteChart.timingData) do
		if timingPoint.layer = self.index then
			local TimingPoint = createClass(timingPoint)
			local timingPoint = TimingPoint:new()
			self.timingData[#self.timingData + 1] = timingPoint
			
			timingPoint.index = #self.timingData
		end
	end
end

Layer.load = function(self)
	self:loadTimingData()
	self:loadColumns()
end

Layer.update = function(self)
	self:updateColumns()
end

Layer.unload = function(self)
	self:unloadColumns()
end

Layer.loadColumns = function(self)
	self.columns = {}
	for index in pairs(game.noteChart.columns) do
		self.columns[index] = game.Column:new({
			index = index
		})
		self.columns[index]:load()
	end
end

Layer.updateColumns = function(self)
	for _, column in pairs(self.columns) do
		column:update()
	end
end

Layer.unloadColumns = function(self)
	for _, column in pairs(self.columns) do
		column:unload()
	end
	self.columns = nil
end