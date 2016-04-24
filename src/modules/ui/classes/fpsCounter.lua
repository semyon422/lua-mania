local fpsCounter = {}

fpsCounter.new = function(self, data)
	local object = {}
	object.data = {}
	object.data.x = data.x or 0
	object.data.y = data.y or 0
	object.data.font = object.data.font or ui.fonts.default
	object.data.r = data.r or 20
	object.update = function()
		loveio.output.objects["fpsCounterCircle"] = {
			class = "circle", x = object.data.x, y = object.data.y, r = object.data.r, mode = "line"
		}
		loveio.output.objects["fpsCounterText"] = {
			class = "text", x = object.data.x, y = object.data.y, text = love.timer.getFPS(), xAlign = "center", yAlign = "center",
			font = object.data.font
		}
	end
	return object
end

return fpsCounter