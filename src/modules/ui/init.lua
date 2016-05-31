local ui = {}

ui.classes = require("ui.classes")
ui.fonts = {
	default = love.graphics.newFont("res/fonts/OpenSans/OpenSansRegular/OpenSansRegular.ttf", 14)
}

ui.update = function(dt)
	if ui.loaded then
	
	else
		objects["fpsCounter"] = ui.classes.fpsCounter:new({x = 20, y = 20, r = 18, font = love.graphics.getFont()})
		objects["someSlider"] = ui.classes.slider:new({x = 30, y = 300, action = function(value)
			objects.background.color = {255 * value, 255 * value, 255 * value}
		end})
		ui.loaded = true
	end
end

return ui