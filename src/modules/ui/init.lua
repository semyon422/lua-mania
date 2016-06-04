local ui = {}

ui.classes = require("ui.classes")
ui.fonts = {
	default = love.graphics.newFont("res/fonts/OpenSans/OpenSansRegular/OpenSansRegular.ttf", 14)
}

ui.update = function(dt)
	if ui.loaded then
	
	else
		ui.classes.button:new({
			name = "fpsDisplay",
			x = 0, y = 0, w = 0.08, h = pos.x2y(0.05),
			getValue = function() return love.timer.getFPS() .. "fps" end,
			action = function(value) print("FPS: " .. value) end,
			apply = true
		})
		ui.classes.button:new({
			name = "latencyDisplay",
			x = 0, y = pos.x2y(0.05), w = 0.08, h = pos.x2y(0.05),
			getValue = function() return math.floor((1000 / love.timer.getFPS()) * 10) / 10 .. "ms" end,
			action = function(value) print("Latency: " .. value) end,
			apply = true
		})
		ui.classes.button:new({
			name = "printObjectsList",
			x = 0, y = pos.x2y(0.1), w = 0.08, h = pos.x2y(0.05),
			value = "print objects",
			action = function()
				print("--objects = {")
				for key, object in pairs(objects) do
					print("--\t[" .. key .. "] = " .. tostring(object))
				end
				print("--}")
			end,
			apply = true
		})
		ui.loaded = true
	end
end

return ui