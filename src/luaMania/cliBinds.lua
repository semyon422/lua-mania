local init = function(luaMania)
--------------------------------
local cliBinds = {}

cliBinds["gameState"] = function(command)
	local breaked = explode(" ", command)
	if breaked[2] == "set" then
		luaMania.ui.objects.gameState.data.state = breaked[3]
		luaMania.ui.objects.gameState.data.switched = false
	end
end

return cliBinds
--------------------------------
end

return init