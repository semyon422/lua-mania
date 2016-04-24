local function lmLoad()
	luaMania.ui.objects = require("luaMania.ui.objects")
	objects.gameState = luaMania.ui.objects.gameState
	
	luaMania.cache.generate()
end

return lmLoad