local fpsCounter = {}

fpsCounter.new = function(self, data)
	local object = {}
	object.data = {}
	object.data.x = data.x or 0
	object.data.y = data.y or 0
	object.data.font = object.data.font or ui.fonts.default
	object.data.r = data.r or 20
	object.data.loaded = false
	object.data.lastFPS = nil
	object.update = function()
		if not object.data.loaded then
			loveio.output.objects["fpsCounterCircle"] = {
				class = "circle", x = object.data.x, y = object.data.y, r = object.data.r, mode = "line"
			}
			object.data.loaded = true
		end
		if object.data.lastFPS ~= love.timer.getFPS() then
			loveio.output.objects["fpsCounterText"] = {
				class = "text", x = object.data.x, y = object.data.y, text = love.timer.getFPS(), xAlign = "center", yAlign = "center",
				font = object.data.font
			}
			object.data.lastFPS = love.timer.getFPS()
		end
	end
	return object
end

return fpsCounter