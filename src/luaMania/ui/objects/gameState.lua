local gameState = loveio.LoveioObject:new()

gameState.data = {
	state = "mainMenu",
	switched = false,
	states = {
		["mainMenu"] = {
			close = {},
			open = {
				"menuBackground",
				"playButton",
				"fpsDisplay",
				"cursor"
			}
		},
		["mapList"] = {
			close = {
				"playButton",
				"game",
				"backButton"
			},
			open = {
				"mapList",
				"menuBackground"
			}
		},
		["game"] = {
			close = {
				"mapList",
				"menuBackground"
			},
			open = {
				"game",
				"backButton"
			}
		}
	}
}
gameState.update = function(self, dt)
	local data = gameState.data
	if not data.switched then
		for _, key in pairs(data.states[data.state].close) do
			if objects[key] then objects[key]:remove() end
		end
		for _, key in pairs(data.states[data.state].open) do
			objects[key] = luaMania.ui.objects[key]
			objects[key]:reload()
		end
		log("gameState: " .. data.state)
		data.switched = true
	end
end

return gameState