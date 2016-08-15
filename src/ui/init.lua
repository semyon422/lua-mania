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
			action = function(self) print("FPS: " .. self.value) end,
			insert = objects
		})
		ui.classes.Button:new({
			name = "latencyDisplay",
			x = 0, y = pos.x2y(0.05), w = 0.08, h = pos.x2y(0.05),
			getValue = function() return math.floor((1000 / love.timer.getFPS()) * 10) / 10 .. "ms" end,
			action = function(self) print("Latency: " .. self.value) end,
			insert = objects
		})
		ui.classes.Button:new({
			name = "goFullscreen",
			x = 1 - 0.08, y = 0, w = 0.08, h = pos.x2y(0.05),
			value = "full\nscreen",
			action = function() love.window.setFullscreen(not (love.window.getFullscreen())) end,
			insert = objects
		})
		ui.classes.Slider:new({
			name = "mover",
			x = 0, y = 0.5, w = 0.2, h = 0.1,
			value = objects.fpsDisplay.x,
			getValue = function() return objects.fpsDisplay.x end,
			action = function(self) objects.fpsDisplay.x = self.value; objects.fpsDisplay:reload(); objects.fpsDisplay:valueChanged() end,
			insert = objects
		})
		ui.classes.Button:new({
			name = "hideLogo",
			x = 1 - 0.08, y = pos.x2y(0.05), w = 0.08, h = pos.x2y(0.05),
			value = true,
			action = function(self)
				for i, v in pairs(objects) do print(i, v) end
			end,
			insert = objects
		})
		-- ui.classes.Button:new({
			-- name = "hideLogo",
			-- x = 1 - 0.08, y = pos.x2y(0.05), w = 0.08, h = pos.x2y(0.05),
			-- value = true,
			-- action = function(self) 
				-- if objects.luaManiaLogo.hidden then
					-- objects.luaManiaLogo:show()
				-- else
					-- objects.luaManiaLogo:hide()
				-- end
				-- self.value = not objects.luaManiaLogo.hidden
			-- end,
			-- insert = objects
		-- })
		-- ui.classes.List:new({
			-- name = "simpleList",
			-- x = 0.5, y = 0, w = 0.3, h = 0.4,
			-- items = {
				-- {
					-- title = "1",
					-- action = function() print(1) end
				-- },
				-- {
					-- title = "2",
					-- action = function() print(2) end
				-- },
				-- {
					-- title = "3",
					-- action = function() print(3) end
				-- },
			-- },
			-- showingItemsCount = 4,
			-- insert = objects
		-- })
		ui.loaded = true
	end
end

return ui