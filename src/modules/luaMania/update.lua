local function update()
	luaMania.ui.update()
	luaMania.graphics.update()
	luaMania.audio.update()
	luaMania.keyboard.update()
end

return update