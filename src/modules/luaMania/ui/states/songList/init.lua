--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
local songList = {}

songList.state = 1

songList.states = {
	[1] = require("luaMania.ui.states.songList.state1")
}

songList.update = function()
	if songList.states[songList.state].actionState == 0 then
		songList.states[songList.state].action(songList.states[songList.state].getButtons())
	end
	
	local buttons = songList.states[songList.state].getButtons()
	for buttonIndex, button in pairs(buttons) do
		for layerIndex, layer in pairs(button.objects) do
			for objectIndex, object in pairs(layer) do
				luaMania.graphics.objects[layerIndex] = luaMania.graphics.objects[layerIndex] or {}
				table.insert(luaMania.graphics.objects[layerIndex], object)
			end
		end
	end
	luaMania.graphics.objects[1] = luaMania.graphics.objects[1] or {}
	table.insert(luaMania.graphics.objects[1], songList.states[songList.state].getBackground())
end

return songList
