local table2string = function(object)
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

return table2string