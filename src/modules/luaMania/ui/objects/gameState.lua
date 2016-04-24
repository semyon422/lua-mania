local gameState = {}

gameState.data = {
	state = "mainMenu",
	switched = false,
	states = {
		["mainMenu"] = {
			close = {},
			open = {
				"background",
				"button123",
				"button456",
				"circle"
			}
		},
		["mapList"] = {
			close = {
				"button123",
				"button456"
			},
			open = {
				"mapList"
			}
		}
	}
}
gameState.update = function(dt)
	local data = gameState.data
	if not data.switched then
		for _, key in pairs(data.states[data.state].close) do
			if objects[key] then objects[key].update(dt, "close") end
		end
		for _, key in pairs(data.states[data.state].open) do
			objects[key] = luaMania.ui.objects[key]
		end
		data.switched = true
	end
end

return gameState