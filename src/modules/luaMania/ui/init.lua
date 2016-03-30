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
			if luaMania.ui.state == "mapList" then
				luaMania.ui.state = "playing"
			elseif luaMania.ui.state == "mainMenu" then
				luaMania.ui.state = "mapList"
			end
		end
	},
	{
		keys = {"up"},
		actionHit = function()
			if luaMania.ui.state == "mapList" then
				if luaMania.state.cachePosition < #luaMania.data.cache then
					luaMania.state.cachePosition = luaMania.state.cachePosition + 1
				end
			end
		end
	},
	{
		keys = {"down"},
		actionHit = function()
			if luaMania.ui.state == "mapList" then
				if luaMania.state.cachePosition > 1 then
					luaMania.state.cachePosition = luaMania.state.cachePosition - 1
				end
			end
		end
	}
}

return ui