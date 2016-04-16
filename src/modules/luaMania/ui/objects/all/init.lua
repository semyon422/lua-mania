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

return all