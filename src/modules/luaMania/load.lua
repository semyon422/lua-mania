local function fLoad()
	lg = love.graphics
	lm = love.mouse
	lt = love.timer
	
	osu = require("osu")
	
	luaMania.data = {
		--keyboard = require(pathprefix .. "keyboard"),
		play = 0,
		beatradius = 1,
		autoplay = 0,
		cache = {},
		BMFList = {},
		currentbeatmap = 1,
		keylocks = {},
		keyhits = {},
		
		stats = {
			hits = {0,0,0,0,0,0},
			mismatch = {},
			averageMismatch = {
				value = 0,
				count = 0
			},
			combo = 0,
			maxCombo = 0
		},
	}
	
	
	--luaMania.graphics.skin = luaMania.graphics.loadSkin(data.config.skinname)
	--luaMania.graphics.skin.init()
	--luaMania.data.cache = luaMania.cache.genCache()
end

return fLoad