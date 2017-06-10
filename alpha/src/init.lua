require("tweaks")
require("soul")

soul.init()

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

dr = soul.ui.RectangleTextButton:new({
	x = 0, y = 0, w = 0.1, h = 0.1,
	mode = "line",
	text = "click",
	limit = 0.1,
	layer = 1,
	cs = cs,
	rectangleColor = {255, 255, 255, 127},
	action = function(self)
		print(1)
	end,
	textAlign = {
		x = "center", y = "center"
	}
})
dr:activate()



