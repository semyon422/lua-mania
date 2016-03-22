local function fLoad()
	lg = love.graphics
	lm = love.mouse
	lt = love.timer
	
	osu = require("osu")
	
	luaMania.data = {
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
	luaMania.cache.generate()
	
	for submoduleIndex, submodule in pairs(luaMania) do
		if type(submodule) == "table" and submodule.keyboard ~= nil then
			for eventIndex, event in pairs(submodule.keyboard) do
				table.insert(luaMania.keyboard.events, event)
			end
		end
	end
end

return fLoad