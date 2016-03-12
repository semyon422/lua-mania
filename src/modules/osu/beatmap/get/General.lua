local function General(blockLines)
	local out = {}
	for numberLine = 1, #blockLines do
		local line = blockLines[numberLine]
		
		if string.sub(line, 1, 13) == "AudioFilename" then
			out.AudioFilename = trim(string.sub(line, 15, -1))
		end
		if string.sub(line, 1, 11) == "AudioLeadIn" then
			out.AudioLeadIn = tonumber(trim(string.sub(line, 13, -1)))
		end
		if string.sub(line, 1, 11) == "PreviewTime" then
			out.PreviewTime = tonumber(trim(string.sub(line, 13, -1)))
		end
		if string.sub(line, 1, 9) == "SampleSet" then
			out.SampleSet = trim(string.sub(line, 11, -1))
		end
		if string.sub(line, 1, 4) == "Mode" then
			out.Mode = tonumber(trim(string.sub(line, 6, -1)))
		end
	end
	return out
end

return General
