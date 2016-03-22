local audio = {}

audio.volume = {}
audio.volume.global = 1
audio.volume.muted = false
audio.availableAudioFormats = {"wav","ogg","mp3"}

audio.start = function(source)
	if source.audio ~= nil then
		source.audio:stop()
	end
	source.startTime = love.timer.getTime() * 1000
end
audio.stop = function(source)
	if source.audio ~= nil then
		source.audio:stop()
	end
end
audio.play = function(source)
	if source.audio ~= nil then
		source.audio:setPitch(source.pitch)
		source.audio:play()
	end
end
audio.pause = function(source)
	if source.audio ~= nil then
		source.audio:pause()
	end
end
audio.update = function(source)
	
end

audio.keyboard = {
	{
		keys = {"lctrl", "m"},
		actionHit = function()
			if audio.volume.muted then
				audio.volume.muted = false
			else
				audio.volume.muted = true
			end
		end
	},
	{
		keys = {"lctrl", "="},
		actionHit = function()
			if audio.volume.global < 1 then
				audio.volume.global = audio.volume.global + 0.01
			end
		end
	},
	{
		keys = {"lctrl", "-"},
		actionHit = function()
			if audio.volume.global > 0 then
				audio.volume.global = audio.volume.global - 0.01
			end
		end
	}
}

return audio