local function Metadata(blockLines)
	local out = {}
	for numberLine = 1, #blockLines do
		local line = blockLines[numberLine]
		
		if string.sub(line, 1, 12) == "TitleUnicode" then
			out.TitleUnicode = trim(string.sub(line, 14, -1))
		end
		if string.sub(line, 1, 13) == "ArtistUnicode" then
			out.ArtistUnicode = trim(string.sub(line, 15, -1))
		end
		if string.sub(line, 1, 7) == "Creator" then
			out.Creator = trim(string.sub(line, 9, -1))
		end
		if string.sub(line, 1, 7) == "Version" then
			out.Version = trim(string.sub(line, 9, -1))
		end
		if string.sub(line, 1, 6) == "Source" then
			out.Source = trim(string.sub(line, 8, -1))
		end
		if string.sub(line, 1, 4) == "Tags" then
			out.Tags = trim(string.sub(line, 6, -1))
		end
	end
	return out
end

return Metadata
