local load = function()
	luaMania.map = luaMania.games.osu.beatmap.import(luaMania.data.cache[luaMania.state.cachePosition].pathFile)
	luaMania.modes.mania.convert()
	luaMania.audio.soundData = love.sound.newSoundData(luaMania.map.pathAudio)
	luaMania.audio.source = love.audio.newSource(luaMania.audio.soundData)
	luaMania.audio.source:play()
end

return load