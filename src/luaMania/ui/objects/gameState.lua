local gameState = loveio.LoveioObject:new()

gameState.data = {
	state = "mainMenu",
	switched = false,
	states = {
		["mainMenu"] = {
			close = {},
			open = {
				"background",
				"playButton",
				"luaManiaLogo",
				"cursor"
			}
		},
		["mapList"] = {
			close = {
				"playButton",
				"luaManiaLogo"
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
				"game"
			}
		}
	}
}
gameState.update = function(self, dt)
	local data = gameState.data
	if not data.switched then
		for _, key in pairs(data.states[data.state].close) do
			if objects[key] then objects[key]:unload() end
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