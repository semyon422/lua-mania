game.gameState = soul.SoulObject:new()
local gameState = game.gameState

gameState.oldState = nil
gameState.state = "mainMenu"

gameState.states = {}
local states = gameState.states

states.mainMenu = {
	deactivate = {
		uiBase["mainMenu"]
	},
	activate = {
		uiBase["background"],
		uiBase["fpsDisplay"],
		uiBase["cursor"],
		uiBase["mainMenu"]
	}
},
states.mapList = {
	deactivate = {
		uiBase["mapList"],
		uiBase["cacheUpdater"]
	},
	activate = {
		uiBase["mapList"],
		uiBase["cacheUpdater"]
	}
},
states.game = {
	deactivate = {
		game
	},
	activate = {
		game
	}
}

gameState.update = function(self)
	local data = self.data
	if data.state ~= data.oldState then
		for _, object in pairs(data.states[data.oldState].deactivate) do
			object:deactivate()
		end
		for _, object in pairs(data.states[data.state].activate) do
			object:activate()
		end
		data.oldState = data.state
	end
end