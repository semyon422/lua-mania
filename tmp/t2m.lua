local function t2m(arg)
	local fileName = arg.fileName or ""
	local alternationType = arg.alternationType or 2
	local hitSoundType = arg.hitSoundType or 1
	local holds = arg.holds
	local doubles = arg.doubles

	local file = io.open(fileName, "r")
	if not file then return end
	local fileLines = {}
	for line in file:lines() do
		table.insert(fileLines, line)
	end
	
	local startLine = 1
	for numberLine, line in ipairs(fileLines) do
		if string.sub(line, 1, 4) == "Mode" then
			if trim(string.sub(line, 6, -1)) == "3" then
				return
			else
				fileLines[numberLine] = "Mode: 3"
			end
		elseif string.sub(line, 1, 10) == "CircleSize" then
			fileLines[numberLine] = "CircleSize: 4"
		elseif string.sub(line, 1, 7) == "Version" then
			fileLines[numberLine] = fileLines[numberLine] .. " [t2m]"
		elseif trim(string.sub(line, 1, -1)) == "[HitObjects]" then
			startLine = numberLine + 1
			break
		end
	end
	
	local function newState(alternationType)
		if alternationType == 1 then
			local state = 1
			return function()
				state = -state
				return state
			end
		elseif alternationType == 2 then
			local donState = 1
			local katState = 1
			return function(noteType)
				if noteType == "don" then
					donState = -donState
					return donState
				elseif noteType == "kat" then
					katState = -katState
					return katState
				end
			end
		end
	end
	local getState = newState(alternationType)
	local function convert(line)
		local hitObject = explode(",", line)
		
		local startTime = tonumber(hitObject[3])
		local noteType = tonumber(hitObject[4])
		local hitSound = tonumber(hitObject[5])
		local endTime = startTime
		local addition = hitObject[#hitObject]
		if #explode(":", addition) < 4 then
			addition = "0:0:0:0:"
		end
		
		if holds then
			if bit.band(noteType, 1) == 1 then
				noteType = 1
			elseif bit.band(noteType, 2) == 2 then
				noteType = 128
				endTime = startTime + tonumber(hitObject[8])
				if endTime % 1 >= 0.5 then endTime = math.ceil(endTime) else endTime = math.floor(endTime) end
			elseif bit.band(noteType, 8) == 8 then
				noteType = 128
				endTime = tonumber(hitObject[6])
				if endTime % 1 >= 0.5 then endTime = math.ceil(endTime) else endTime = math.floor(endTime) end
			end
		else
			noteType = 1
		end
		
		local taikoNoteType = ""
		local isDouble = false
		if hitSound == 0 or hitSound == 4 then
			taikoNoteType = "don"
			if doubles and hitSound == 4 then
				isDouble = true
			end
		else
			taikoNoteType = "kat"
			if doubles and (hitSound == 6 or hitSound == 12 or hitSound == 14) then
				isDouble = true
			end
		end
		
		if not isDouble then
			local x = 0
			local state = getState(taikoNoteType)
			if taikoNoteType == "don" then
				if state == 1 then x = 320 -- 3rd key
				elseif state == -1 then x = 192 -- 2nd key
				end
			elseif taikoNoteType == "kat" then
				if state == 1 then x = 448 -- 4th key
				elseif state == -1 then x = 64 -- 1st key
				end
			end
			if noteType == 1 then
				return table.concat({x, "192", startTime, noteType, hitSound, addition}, ",")
			else
				return table.concat({x, "192", startTime, noteType, hitSound, endTime .. ":" .. addition}, ",")
			end
		else
			local x1 = 0
			local x2 = 0
			if taikoNoteType == "don" then
				x1 = 192
				x2 = 320
			elseif taikoNoteType == "kat" then
				x1 = 64
				x2 = 448
			end
			if noteType == 1 then
				return  table.concat({x1, "192", startTime, noteType, hitSound, addition}, ",") .. "\n" ..
						table.concat({x2, "192", startTime, noteType, hitSound, addition}, ",")
			else
				return  table.concat({x1, "192", startTime, noteType, hitSound, endTime .. ":" .. addition}, ",") .. "\n" ..
						table.concat({x2, "192", startTime, noteType, hitSound, endTime .. ":" .. addition}, ",")
			end
		end
	end
	
	local newFileLines = {}
	for numberLine = 1, startLine - 1 do
		table.insert(newFileLines, fileLines[numberLine])
	end
	for numberLine = startLine, #fileLines do
		table.insert(newFileLines, convert(fileLines[numberLine]))
	end
	local newFileString = table.concat(newFileLines, "\n")
	
	local newFile = io.open(string.sub(fileName, 1, -6) .. " [t2m]].osu", "w+")
	newFile:write(newFileString)
end

return t2m




