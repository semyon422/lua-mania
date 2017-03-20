function tablePrint(tbl, i)
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

local vardump = function(variable)
	print("vardump: " .. tostring(variable))
	if type(variable) == "table" then
		tablePrint(variable)
	end
end

return vardump