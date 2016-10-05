local init = function(lmObjects, lmui, luaMania)
--------------------------------
local gameState = loveio.LoveioObject:new()

gameState.data = {
	state = "mainMenu",
	switched = false,
	states = {
		["mainMenu"] = {
			close = {},
			open = {
				lmObjects["menuBackground"],
				lmObjects["playButton"],
				lmObjects["fpsDisplay"],
				lmObjects["cursor"],
				lmObjects["cliUi"]
			}
		},
		["mapList"] = {
			close = {
				lmObjects["playButton"],
				lmObjects["game"],
				lmObjects["backButton"]
			},
			open = {
				lmObjects["mapList"],
				lmObjects["menuBackground"]
			}
		},
		["game"] = {
			close = {
				lmObjects["mapList"],
				lmObjects["menuBackground"]
			},
			open = {
				lmObjects["game"],
				lmObjects["backButton"]
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
			objects[tostring(object)] = object
			object:reload()
			print(object)
		end
		log("gameState: " .. data.state)
		data.switched = true
	end
end

return gameState
--------------------------------
end

return init