local init = function(vsrg, game)
--------------------------------
local Column = {}

Column.loadNoteData = function()

end

Column.load = function(self)
	self:loadNoteData()
end
Column.unload = function(self)
end
Column.update = function(self)
end

return Column
--------------------------------
end

return init
