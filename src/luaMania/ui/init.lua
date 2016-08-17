local init = function(luaMania)
--------------------------------
local ui = {}

ui.state = "mainMenu"
ui.mode = 0

--ui.skin = require("res.skin")(ui, luaMania)

ui.tupdate = function()
	ui.states[ui.state].update()
end

return ui
--------------------------------
end

return init