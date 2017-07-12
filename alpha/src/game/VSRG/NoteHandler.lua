game.VSRG.NoteHandler = createClass()
local NoteHandler = game.VSRG.NoteHandler

NoteHandler.loadNoteData = function(self)
	self.noteBaseData = self.vsrg.noteChart:selectNotes({
		hitable = true,
		columnIndex = self.columnIndex
	})
	
	self.noteData = {}
	for _, note in ipairs(self.noteBaseData) do
		self.noteData[#self.noteData + 1] = createClass(note):new({
			noteHandler = self,
			layer = self.layer,
			vsrg = self.vsrg
		})
		
		note.index = #self.noteData
	end
	
	self.startNoteIndex = 1
	self.currentNote = self.noteData[1]
end

NoteHandler.load = function(self)
	self:loadNoteData()
	self.drawingNotes = {}
	
	--set press callback
	--set unpress callback
end

NoteHandler.update = function(self)
	self.currentNote:update()
end

NoteHandler.unload = function(self)

end