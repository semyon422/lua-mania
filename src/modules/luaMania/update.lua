local function update()
	for submoduleIndex, submodule in pairs(luaMania) do
		if type(submodule) == "table" and type(submodule.update) == "function" then
			submodule.update()
		end
	end
	love.window.setTitle("FPS: " .. love.timer.getFPS())
end

return update