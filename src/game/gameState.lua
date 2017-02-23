local init = function(game)
--------------------------------
local gameState = loveio.LoveioObject:new()

gameState.data = {
	loaded = false,
	oldState = "mainMenu",
	state = "mainMenu",
	states = {
		["mainMenu"] = {
			close = {
				uiBase["mainMenu"]
			},
			open = {
				uiBase["background"],
				uiBase["fpsDisplay"],
				uiBase["cursor"],
				uiBase["mainMenu"]
			}
		},
		["mapList"] = {
			close = {
				uiBase["mapList"],
				uiBase["cacheUpdater"]
			},
			open = {
				uiBase["mapList"],
				uiBase["cacheUpdater"]
			}
		},
		["game"] = {
			close = {
				game,
				--uiBase["backButton"]
			},
			open = {
				game,
				--uiBase["backButton"]
			}
		}
	}
}
gameState.update = function(self, dt)
	local data = gameState.data
	if data.state ~= data.oldState or not data.loaded then
		for _, object in pairs(data.states[data.oldState].close) do
			object:remove()
		end
		for _, object in pairs(data.states[data.state].open) do
			object:insert(loveio.objects):reload()
		end
		log("gameState: " .. data.state)
		data.oldState = data.state
		if not data.loaded then data.loaded = true end
	end
end

return gameState
--------------------------------
end

return init
