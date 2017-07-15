NoteChart = createClass()
local NoteChart = NoteChart

require("NoteChart.Parser")
require("NoteChart.OsuParser")

NoteChart.parse = function(self, path)
	-- detect format
	-- create ParsedData object
	-- move data from parsedData to noteChart
end