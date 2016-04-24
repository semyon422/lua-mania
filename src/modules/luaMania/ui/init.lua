local ui = {}

ui.state = "mainMenu"
ui.mode = 0

ui.skin = require("res.skin")

ui.tupdate = function()
	ui.states[ui.state].update()
end

return ui