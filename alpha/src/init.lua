require("tweaks")
require("soul")

soul.init()

require("NoteChart")

require("game")

cs = soul.CS:new({
	res = {
		w = 1, h = 1
	},
	align = {
		x = "center", y = "center"
	},
	locate = "in"
})

noteChart = NoteChart:new()
noteChart:parse("res/Songs/osu!/499185 Warak - REANIMATE/Warak - REANIMATE (Kuo Kyoka) [Avalon's 4K Hyper].osu")

for k, v in ipairs(noteChart.noteData) do
	print(k, v.startTime)
end

-- vsrg = game.VSRG:new()
-- vsrg:setNoteChart()
-- vsrg:activate()


