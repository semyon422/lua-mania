local ui = {}

ui.state = "mainMenu"
ui.mode = 0

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
			if ui.states.songList.cachePosition < #luaMania.data.cache then
				ui.states.songList.cachePosition = ui.states.songList.cachePosition + 1
			end
		end
	},
	{
		keys = {"down"},
		actionHit = function()
			if ui.states.songList.cachePosition > 1 then
				ui.states.songList.cachePosition = ui.states.songList.cachePosition - 1
			end
		end
	}
}

return ui