NoteChart = createClass()
local NoteChart = NoteChart

require("NoteChart.Note")
require("NoteChart.TimingPoint")
require("NoteChart.Parser")
require("NoteChart.OsuParser")

NoteChart.parse = function(self, path)
	self.noteData = {}
	self.timingData = {}
	self.metaData = {}
	
	self.osuParser = self.OsuParser:new()
	self.osuParser.noteChart = self
	self.osuParser.filePath = path
	self.osuParser:parse()
end