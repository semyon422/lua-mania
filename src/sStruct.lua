require("tweaks")
local sStruct = {}

local openSymbol = "{"
local closeSymbol = "}"
local separateSymbol = ","

sStruct.import = function(inString, data)
	local data = data or {
		offset = 0,
		counter = 0,
		cP = 1
	}
	local outTable = {}

	local startCounter = data.counter

	while true do
		local currentSymbol = inString:sub(data.cP, data.cP)
		if currentSymbol == separateSymbol then
			if inString:sub(data.cP - 1, data.cP - 1) ~= closeSymbol then
				local value = inString:sub(1 + data.offset, data.cP - 1)
				data.offset = data.cP
				table.insert(outTable, value)
			else
				data.offset = data.cP
			end
		elseif data.cP == #inString and currentSymbol ~= closeSymbol then
			local value = inString:sub(1 + data.offset, data.cP)
			data.offset = data.cP
			table.insert(outTable, value)
		elseif currentSymbol == openSymbol then
			local key = inString:sub(1 + data.offset, data.cP - 1)
			data.offset = data.cP
			data.counter = data.counter + 1
			data.cP = data.cP + 1
			outTable[key] = sStruct.import(inString, data)
		elseif currentSymbol == closeSymbol then
			local value = inString:sub(1 + data.offset, data.cP - 1)
			if value ~= "" then
				data.offset = data.cP
				table.insert(outTable, value)
			end
			data.counter = data.counter - 1
			data.cP = data.cP
			data.offset = data.cP
			if data.counter + 1 == startCounter then
				break
			end
		end
		if data.cP == #inString then break end
		data.cP = data.cP + 1
	end

	local keyCount = 0
	for i, v in pairs(outTable) do
		keyCount = keyCount + 1
	end
	if keyCount == 1 and outTable[1] then
		outTable = outTable[1]
	elseif keyCount == 0 then
		outTable = nil
	end

	return outTable
end

sStruct.export = function(inTable)

end

return sStruct
