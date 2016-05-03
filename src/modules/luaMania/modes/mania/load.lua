local load = function()
	luaMania.map = osu.beatmap.import(luaMania.cache.data[luaMania.cache.position].pathFile)
	luaMania.modes.mania.convert()
	luaMania.audio.soundData = love.sound.newSoundData(luaMania.map.pathAudio)
	luaMania.audio.source = love.audio.newSource(luaMania.audio.soundData)
	luaMania.audio.source:play()
end

return load