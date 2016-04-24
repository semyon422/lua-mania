local ui = {}

ui.classes = require("ui.classes")
ui.fonts = {
	default = love.graphics.newFont("res/fonts/OpenSans/OpenSansRegular/OpenSansRegular.ttf", 14)
}

ui.update = function(dt)
	if ui.loaded then
	
	else
		objects["fpsCounter"] = ui.classes.fpsCounter:new({x = 20, y = 20, r = 18, font = ui.fonts.default})
		ui.loaded = true
	end
end

return ui