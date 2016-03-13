local audio = {
	availableAudioFormats = {"wav","ogg","mp3"},
	start = function(source)
		if source.audio ~= nil then
			source.audio:stop()
		end
		source.startTime = love.timer.getTime() * 1000
	end,
	stop = function(source)
		if source.audio ~= nil then
			source.audio:stop()
		end
	end,
	play = function(source)
		if source.audio ~= nil then
			source.audio:setPitch(source.pitch)
			source.audio:play()
		end
	end,
	pause = function(source)
		if source.audio ~= nil then
			source.audio:pause()
		end
	end,
	update = function(source)
		
	end,

}

return audio