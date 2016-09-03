local init = function(luaMania)
--------------------------------
local ui = {}

ui.objects = require("luaMania.ui.objects")(ui, luaMania)

loveio.input.callbacks.keypressed.goFullscreen = function(key)
	if key == "f11" then
		love.window.setFullscreen(not (love.window.getFullscreen()))
	end
end

return ui
--------------------------------
end

return init