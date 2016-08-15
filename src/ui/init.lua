local ui = {}

ui.classes = require("ui.classes")(ui)
ui.fonts = {
	default = love.graphics.newFont("res/fonts/OpenSans/OpenSansRegular/OpenSansRegular.ttf", 12)
}

ui.update = function(dt)
	if ui.loaded then
	
	else
		ui.classes.Button:new({
			name = "fpsDisplay",
			x = 0, y = 0, w = 0.08, h = pos.x2y(0.05),
			getValue = function() return love.timer.getFPS() .. "fps" end,
			action = function(object) print("FPS: " .. object.value) end,
			apply = true
		})
		ui.classes.Button:new({
			name = "latencyDisplay",
			x = 0, y = pos.x2y(0.05), w = 0.08, h = pos.x2y(0.05),
			getValue = function() return math.floor((1000 / love.timer.getFPS()) * 10) / 10 .. "ms" end,
			action = function(object) print("Latency: " .. object.value) end,
			apply = true
		})
		ui.classes.Button:new({
			name = "goFullscreen",
			x = 1 - 0.08, y = 0, w = 0.08, h = pos.x2y(0.05),
			value = "full\nscreen",
			action = function() love.window.setFullscreen(not (love.window.getFullscreen())) end,
			apply = true
		})
		ui.classes.Slider:new({
			name = "mover",
			x = 0, y = 0.5, w = 0.2, h = 0.1,
			value = objects.fpsDisplay.x,
			getValue = function() return objects.fpsDisplay.x end,
			action = function(object) objects.fpsDisplay.x = object.value; objects.fpsDisplay:reload() end,
			apply = true
		})
		ui.classes.Button:new({
			name = "hideLogo",
			x = 1 - 0.08, y = pos.x2y(0.05), w = 0.08, h = pos.x2y(0.05),
			value = true,
			action = function(object) 
				if objects.luaManiaLogo.hidden then objects.luaManiaLogo.update("show")
				else objects.luaManiaLogo.update("hide") end
				object.value = not objects.luaManiaLogo.hidden
			end,
			apply = true
		})
		ui.loaded = true
	end
end

return ui