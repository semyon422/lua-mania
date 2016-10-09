local init = function(lmui, luaMania)
--------------------------------
local gameState = loveio.LoveioObject:new()

gameState.data = {
	state = "mainMenu",
	switched = false,
	states = {
		["mainMenu"] = {
			close = {},
			open = {
				lmui["menuBackground"],
				lmui["playButton"],
				lmui["fpsDisplay"],
				lmui["cursor"],
				lmui["cliUi"]
			}
		},
		["mapList"] = {
			close = {
				lmui["playButton"],
				lmui["game"],
				lmui["backButton"]
			},
			open = {
				lmui["mapList"],
			}
		},
		["game"] = {
			close = {
				lmui["mapList"],
			},
			open = {
				lmui["game"],
				lmui["backButton"]
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