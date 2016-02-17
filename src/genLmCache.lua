local function generateCache(self)
	cache = data.cache
	local BMFList = data.BMFList
	for index,info in pairs(BMFList) do
		local raw = io.open("res/Songs/" .. info[1] .. "/" .. info[2], "r")
		local rawTable = {}
		for line in raw:lines() do
			table.insert(rawTable, line)
		end
		raw:close()
		local title = ""
		local artist = ""
		local audio = ""
		local difficulity = ""
		local creator = ""
		local source = ""
		for gLine = 1, #rawTable do
			if explode(":", tostring(rawTable[gLine]))[1] == "audioFilename" then
				audio = trim(tostring(explode(":", tostring(rawTable[gLine]))[2]))
			end
			if explode(":", tostring(rawTable[gLine]))[1] == "title" then
				title = trim(tostring(explode(":", tostring(rawTable[gLine]))[2]))
			end
			if explode(":", tostring(rawTable[gLine]))[1] == "artist" then
				artist = trim(tostring(explode(":", tostring(rawTable[gLine]))[2]))
			end
			if explode(":", tostring(rawTable[gLine]))[1] == "version" then
				difficulity = trim(tostring(explode(":", tostring(rawTable[gLine]))[2]))
			end
			if explode(":", tostring(rawTable[gLine]))[1] == "creator" then
				creator = trim(tostring(explode(":", tostring(rawTable[gLine]))[2]))
			end
			if explode(":", tostring(rawTable[gLine]))[1] == "source" then
				source = trim(tostring(explode(":", tostring(rawTable[gLine]))[2]))
				if source == "" then source = "No source" end
			end
			if #explode("vent", tostring(rawTable[gLine])) == 2 then
				break
			end
		end
		table.insert(cache, {
			title = title,
			artist = artist,
			difficulity = difficulity,
			audio = audio,
			audioFile = audio,
			pathAudio = "res/Songs/" .. info[1] .. "/" .. audio,
			pathFile = "res/Songs/" .. info[1] .. "/" .. info[2],
			path = "res/Songs/" .. info[1],
			creator = creator,
			source = source
			})
	end
end

return generateCache