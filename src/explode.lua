local function explode(divider, input)
	if (divider == "") then
		return false
	end
	local position = 0
	local output = {}
	
	for endchar,startchar in	function()
									return string.find(input, divider, position, true)
								end
	do
		table.insert(output, string.sub(input, position, endchar - 1))
		position = startchar + 1
	end
	table.insert(output, string.sub(input, position))
	return output
end

return explode