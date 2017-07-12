require("tweaks")
require("soul")

soul.init()

require("nclib")

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

noteChart = nclib.BMSNoteChart:new()

vsrg = game.VSRG:new()
vsrg:setNoteChart()
vsrg:activate()


