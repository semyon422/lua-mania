local init = function(vsrg, game)
--------------------------------
local Layer = {}

Layer.loadTimingData = function()

end

Layer.loadColumns = function(self)
	self.columns = {}
	for key = 1, self.vsrg.noteChart.metaData.keyMode do
		table.insert(self.columns, self.Column:new(key))
	end
end
Layer.unloadColumns = function(self)
	for _, column in ipairs(self.columns) do
		column:unload()
	end
end
Layer.updateColumns = function(self)
	for _, column in ipairs(self.columns) do
		column:update()
	end
end

Layer.load = function(self)
	self:loadTimingData()
	self:loadColumns()
end
Layer.unload = function(self)
	self:unloadColumns()
end
Layer.update = function(self)
	self:updateColumns()
end

return Layer
--------------------------------
end

return init
