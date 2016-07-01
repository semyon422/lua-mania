local beatmap = {}

beatmap.get = require("osu.beatmap.get")

beatmap.import = function(path)
	local out = {}
	local file = io.open(path, "r")
	local fileLines = {}
	
	for line in file:lines() do
		local line = line:match("^%s*(.-)%s*$")
		if line ~= "" then
			table.insert(fileLines, line)
		end
	end
	
	local blocks = {}
	
	local lastBlock = nil
	for numberLine = 1, #fileLines do
		local line = fileLines[numberLine]
		if string.sub(line, 1, 1) == "[" then
			lastBlock = string.sub(line, 2, -2)
			blocks[lastBlock] = {}
		elseif lastBlock then
			table.insert(blocks[lastBlock], line)
		end
	end
	
	for block, blockLines in pairs(blocks) do
		out[block] = beatmap.get[block](blockLines)
	end
	return out
end
beatmap.export = function(tbl, path)
	local function basicSerialize(var)
		if type(var) == "number" then
			return tostring(var)
		elseif type(value) == "boolean" then
			return tostring(var)
		else
			return string.format("%q", tostring(var))
		end
	end
	local function save(name, value, saved, file)
		saved = saved or {}
		file:write(name, " = ")
		if type(value) == "number" or type(value) == "string" or type(value) == "boolean" then
			file:write(basicSerialize(value), "\n")
		elseif type(value) == "table" then
			if saved[value] then
				file:write(saved[value], "\n")
			else
				saved[value] = name
				file:write("{}\n")
				for k,v in pairs(value) do
					k = basicSerialize(k)
					local fname = string.format("%s[%s]", name, k)
					save(fname, v, saved, file)
				end
			end
		else
			error("cannot save a " .. type(value))
		end
	end
	local file = io.open("333.lua", "w+")
	save("beatmap", tbl, {}, file)
end

return beatmap