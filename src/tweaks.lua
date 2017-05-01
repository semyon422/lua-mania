tablePrint = function(tbl, i)
	if not i then i = 0 end
	for k, v in pairs(tbl) do
		io.write(string.rep("  ", i) .. k .. ": ")
		if type(v) == "table" then
			io.write("\n")
			tablePrint(v, i+1)
		else
			print(v)
		end
	end
end

vardump = function(variable)
	print("vardump: " .. tostring(variable))
	if type(variable) == "table" then
		tablePrint(variable)
	end
end

string.trim = function(self)
	return self:match("^%s*(.-)%s*$")
end

string.split = function(self, divider)
	-- if (divider == "") then
		-- return false
	-- end
	local position = 0
	local output = {}
	
	for endchar,startchar in function() return self:find(divider, position, true) end do
		table.insert(output, self:sub(position, endchar - 1))
		position = startchar + 1
	end
	table.insert(output, self:sub(position))
	
	return output
end

string.startsWith = function(self, subString)
	return line:sub(1, #subString) == subString
end

string.endsWith = function(self, subString)
	return line:sub(#self - #subString + 1, -1) == subString
end

string.parse = function(self, startPos, endPos)
	local value = self:trim():sub(startPos or 1, endPos or -1)
	local numValue = tonumber(value)
	
	return numValue or value
end

table.export = function(object)
	local object = object or {}
	local out = {}
	table.insert(out, "{")
	for key, value in pairs(object) do
		local key = key
		if type(key) == "number" then
			key = "[" .. key .. "]"
		end
		if type(value) == "string" then
			table.insert(out, key .. " = " .. string.format("%q", value) .. ", ")
		elseif type(value) == "number" then
			table.insert(out, key .. " = " .. value .. ", ")
		end
	end
	table.insert(out, "}")
	
	return table.concat(out)
end