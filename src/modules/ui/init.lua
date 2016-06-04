local ui = {}

ui.classes = require("ui.classes")
ui.fonts = {
	default = love.graphics.newFont("res/fonts/OpenSans/OpenSansRegular/OpenSansRegular.ttf", 14)
}

ui.update = function(dt)
	if ui.loaded then
	
	else
		objects["fpsDisplay"] = ui.classes.button:new({
			x = 0, y = 0, w = 0.08, h = pos.x2y(0.05),
			getValue = function() return love.timer.getFPS() .. "fps" end,
			action = function(value) print("FPS: " .. value) end
		})
		objects["latencyDisplay"] = ui.classes.button:new({
			x = 0, y = pos.x2y(0.05), w = 0.08, h = pos.x2y(0.05),
			getValue = function() return math.floor((1000 / love.timer.getFPS()) * 10) / 10 .. "ms" end,
			action = function(value) print("Latency: " .. value) end
		})
		ui.loaded = true
	end
end

return ui