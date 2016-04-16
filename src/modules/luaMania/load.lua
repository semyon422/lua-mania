local function fLoad()
	luaMania.ui.classes = require("luaMania.ui.classes")
	luaMania.ui.objects.all = require("luaMania.ui.objects.all")
	luaMania.ui.objects.current = require("luaMania.ui.objects.current")
	
	luaMania.games = {}
	luaMania.games.osu = require("osu")
	luaMania.games.current = "osu"
	
	
	--luaMania.graphics.skin = luaMania.graphics.loadSkin(data.config.skinname)
	--luaMania.graphics.skin.init()
	luaMania.cache.generate()
end

return fLoad