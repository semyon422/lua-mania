local startsWith = function(line, subString)
	return string.sub(line, 1, #subString) == subString
end

return startsWith
