local ui = {}

ui.state = "mainMenu"
ui.mode = 0

ui.skin = require("res.skin")

ui.states = {
	mainMenu = require("luaMania.ui.states.mainMenu"),
	mapList = require("luaMania.ui.states.mapList"),
	playing = require("luaMania.ui.states.playing")
}

ui.update = function()
	ui.states[ui.state].update()
end

ui.keyboard = {
	{
		keys = {"return"},
		actionHit = function()
			luaMania.ui.state = "playing"
		end
	},
	{
		keys = {"up"},
		actionHit = function()
			if ui.states.mapList.cachePosition < #luaMania.data.cache then
				ui.states.mapList.cachePosition = ui.states.mapList.cachePosition + 1
			end
		end
	},
	{
		keys = {"down"},
		actionHit = function()
			if ui.states.mapList.cachePosition > 1 then
				ui.states.mapList.cachePosition = ui.states.mapList.cachePosition - 1
			end
		end
	}
}

return ui