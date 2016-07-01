local function update()
	for submoduleIndex, submodule in pairs(luaMania) do
		if type(submodule) == "table" and type(submodule.update) == "function" then
			--submodule.update()
		end
	end
end

return update