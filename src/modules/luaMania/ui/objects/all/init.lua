local all = {}

all.background = {
	update = function()
		table.insert(luaMania.ui.output.objects[1], {
			class = "rectangle",
			x = 0, y = 0,
			w = love.graphics.getWidth(), h = love.graphics.getHeight(),
			color = {63, 63, 63}
		})
	end
}
all.circle = require("luaMania.ui.objects.all.circle")
all.logo = require("luaMania.ui.objects.all.mainMenu.logo")
all.button = luaMania.ui.classes.button:new({
	name = "button",
	x = 100,
	y = 100,
	form = "circle",
	r = 20,
	mode = "line",
	text = "t",
	color = {255,255,255},
	textColor = {255,255,255},
	action = function() end
})
all.button1 = luaMania.ui.classes.button:new({
	name = "button1",
	x = 100,
	y = 200,
	form = "rectangle",
	mode = "line",
	text = "text",
	color = {255,255,255},
	textColor = {255,255,255},
	action = function() end
})

return all