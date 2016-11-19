local init = function(game)
--------------------------------
local gameState = loveio.LoveioObject:new()

gameState.data = {
	state = "mapList",
	switched = false,
	states = {
		["mapList"] = {
			close = {
				game,
				uiBase["backButton"]
			},
			open = {
				uiBase["menuBackground"],
				uiBase["fpsDisplay"],
				uiBase["cursor"],
				uiBase["mapList"],
			}
		},
		["game"] = {
			close = {
				uiBase["mapList"],
			},
			open = {
				game,
				uiBase["backButton"]
			}
		}
	}
}
gameState.update = function(self, dt)
	local data = gameState.data
	if not data.switched then
		for _, object in pairs(data.states[data.state].close) do
			object:remove()
		end
		for _, object in pairs(data.states[data.state].open) do
			object:insert(loveio.objects):reload()
		end
		log("gameState: " .. data.state)
		data.switched = true
	end
end

return gameState
--------------------------------
end

return init