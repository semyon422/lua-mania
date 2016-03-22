--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
local mainMenu = {}

mainMenu.state = 1

mainMenu.states = {
	[1] = require("luaMania.ui.states.mainMenu.state1"),
	[2] = require("luaMania.ui.states.mainMenu.state2")
}
mainMenu.update = function()
	if mainMenu.states[mainMenu.state].actionState == 0 then
		mainMenu.states[mainMenu.state].action(mainMenu.states[mainMenu.state].getButtons())
	end
	
	local buttons = mainMenu.states[mainMenu.state].getButtons()
	for buttonIndex, button in pairs(buttons) do
		for layerIndex, layer in pairs(button.objects) do
			for objectIndex, object in pairs(layer) do
				luaMania.graphics.objects[layerIndex] = luaMania.graphics.objects[layerIndex] or {}
				table.insert(luaMania.graphics.objects[layerIndex], object)
			end
		end
	end
	luaMania.graphics.objects[1] = luaMania.graphics.objects[1] or {}
	table.insert(luaMania.graphics.objects[1], mainMenu.states[mainMenu.state].getBackground())
end

return mainMenu
