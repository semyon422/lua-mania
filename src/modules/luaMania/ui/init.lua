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

return ui