local function Difficulity(blockLines)
	local out = {}
	for numberLine = 1, #blockLines do
		local line = blockLines[numberLine]
		
		if string.sub(line, 1, 10) == "CircleSize" then
			out.CircleSize = tonumber(trim(string.sub(line, 12, -1)))
		end
		if string.sub(line, 1, 17) == "OverallDifficulty" then
			out.OverallDifficulty = tonumber(trim(string.sub(line, 19, -1)))
		end
		if string.sub(line, 1, 16) == "SliderMultiplier" then
			out.SliderMultiplier = tonumber(trim(string.sub(line, 18, -1)))
		end
	end
	return out
end

return Difficulity
