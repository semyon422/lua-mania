local audio = {}

audio.volume = {}
audio.volume.global = 1
audio.volume.muted = false
audio.availableAudioFormats = {"wav","ogg","mp3"}


audio.update = function(source)
	if luaMania.map then
		local stats = luaMania.map.stats
		if stats.currentTime < 0 then
			stats.currentTime = math.floor(love.timer.getTime() * 1000 - stats.startTime)
		elseif stats.currentTime >= 0 then
			luaMania.audio.source:play()
			stats.currentTime =  math.floor(luaMania.audio.source:tell() * 1000)
		end
	end
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