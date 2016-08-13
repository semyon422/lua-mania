local mania = {}

mania.convert = require("luaMania.modes.mania.osu")
mania.getObjects = require("luaMania.modes.mania.getObjects")
mania.hit = require("luaMania.modes.mania.hit")

mania.name = "mania"
mania.keys = {
	binds = {["e"] = 1, ["r"] = 2, ["o"] = 3, ["p"] = 4},
	pressed = {},
	hitted = {}
}
mania.loaded = false
mania.map = {}

mania.update = function()
	if not mania.loaded then
		mania.map = osu.beatmap.import(luaMania.cache.data[luaMania.cache.position].pathFile)
		mania.map = mania.convert(mania.map)
		--luaMania.audio.soundData = love.sound.newSoundData(mania.map.pathAudio)
		--luaMania.audio.source = love.audio.newSource(mania.audio.soundData)
		luaMania.audio.source = love.audio.newSource(mania.map.pathAudio)
		luaMania.audio.source:play()
		
		mania.loaded = true
	end
	mania.getObjects({map = mania.map})
end

return mania