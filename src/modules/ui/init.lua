local ui = {}

ui.classes = require("ui.classes")
ui.fonts = {
	default = love.graphics.newFont("res/fonts/OpenSans/OpenSansRegular/OpenSansRegular.ttf", 14)
}

ui.update = function(dt)
	if ui.loaded then
	
	else
		objects["fpsCounter"] = ui.classes.button:new({x = 0, y = 0, w = 0.05, h = pos.x2y(0.05), getValue = love.timer.getFPS, action = function(value) print("FPS: " .. value) end})
		ui.loaded = true
	end
end

return ui