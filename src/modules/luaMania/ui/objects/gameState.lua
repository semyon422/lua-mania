local gameState = {}

gameState.data = {
	state = "mainMenu",
	switched = false,
	states = {
		["mainMenu"] = {
			close = {},
			open = {
				"background",
				"buttonPlay"
			}
		},
		["mapList"] = {
			close = {
				"buttonPlay",
			},
			open = {
				"mapList"
			}
		},
		["game"] = {
			close = {
				"mapList",
			},
			open = {
				"mania"
			}
		}
	}
}
gameState.update = function(dt)
	local data = gameState.data
	if not data.switched then
		for _, key in pairs(data.states[data.state].close) do
			if objects[key] then objects[key].update("close") end
		end
		for _, key in pairs(data.states[data.state].open) do
			objects[key] = luaMania.ui.objects[key]
		end
		log("gameState: " .. data.state)
		data.switched = true
	end
end

return gameState