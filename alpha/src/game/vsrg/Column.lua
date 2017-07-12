game.VSRG.Column = createClass()
local Column = game.VSRG.Column

Column.loadNoteData = function(self)
	self.noteData = {}
	for _, note in ipairs(self.game.noteChart.noteData) do
		if note.layer == self.layer.index and note.column == self.index then
			local note = createClass(note):new({
				column = self,
				layer = self.layer,
				vsrg = self.vsrg
			})
			self.noteData[#self.noteData + 1] = note
			
			note.index = #self.noteData
		end
	end
	self.startNoteIndex = 1
	self.currentNote = self.noteData[1]
end

Column.load = function(self)
	self:loadNoteData()
	self.drawingNotes = {}
	
	--set press callback
	--set unpress callback
end

Column.update = function(self)
	self.currentNote:update()
	self:draw()
end

Column.unload = function(self)

end

Column.draw = function(self)
	for noteIndex = self.startNoteIndex, #self.noteData do
		local note = self.noteData[noteIndex]
		if note then
			if note:willDrawEarly() then
				break
			else
				note:activate()
				self.startNoteIndex = noteIndex + 1
			end
		end
	end
	for _, note in pairs(self.drawingNotes) do
		if self:willDrawLate() then
			note:deactivate()
		else
			note:draw()
		end
	end
end