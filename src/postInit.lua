local keypressed = loveio.input.callbacks.keypressed

keypressed.printProfilersInfo = function(key)
	if key == "f10" then
		local updateDelta = string.format("%0.2f", loveio.updateProfiler:getDelta())
		local drawDelta = string.format("%0.2f", loveio.drawProfiler:getDelta())
		local globalDelta = drawDelta + updateDelta
		print("profilers: callbacks, upate, draw")
		print("upd: " .. updateDelta .. "ms " .. string.format("%0.2f", updateDelta / globalDelta * 100) .. "%")
		print("drw: " .. drawDelta .. "ms " .. string.format("%0.2f", drawDelta / globalDelta * 100) .. "%")
	end
end



cacheCallback = function(filePath)
	if love.filesystem.isFile(filePath) then
		local breaked = explode(".", filePath)
		local fileType = breaked[#breaked]
		if fileType == "osu" then
			return osu.Beatmap.genCache(filePath)
		end
		if fileType == "bms" or fileType == "bme" then
			return bms.Beatmap.genCache(filePath)
		end
		if fileType == "lmx" then
			return lmx.Beatmap.genCache(filePath)
		end
	end
end
cacheRules = {
	path = "res/Songs/",
	callback = cacheCallback
}
keypressed.cacheHandle = function(key)
	if uiBase.mapList.state == "songs" then
		if key == "f7" then
			mainCache = cacheManager.generate(cacheRules)
			if loveio.objects[tostring(uiBase.mapList)] then
				uiBase.mapList.list = mainCache
				uiBase.mapList:calcButtons()
			end
		elseif key == "f8" then
			cacheManager.save(mainCache, "cache.lua")
		elseif key == "f9" then
			mainCache = cacheManager.load("cache.lua")
			if loveio.objects[tostring(uiBase.mapList)] then
				uiBase.mapList.list = mainCache
				uiBase.mapList:calcButtons()
			end
		end
	end
end

mainCli:bind("gameState", function(command)
	local breaked = explode(" ", command)
	if breaked[2] == "set" then
		game.gameState.data.state = breaked[3]
		game.cachePosition = tonumber(breaked[4]) or 1
		game.gameState.data.switched = false
	end
end)


local windowMode = windowManager.Mode:new(800, 600, {
	fullscreen = false, fullscreentype = "desktop",
	vsync = false, msaa = 0,
	resizable = true,
})
local desktopWidth, desktopHeight = love.window.getDesktopDimensions()
local fullscreenMode = windowManager.Mode:new(desktopWidth, desktopHeight, {
	fullscreen = true, fullscreentype = "desktop",
	vsync = false, msaa = 0,
	resizable = true,
})
local highPerformanceMode = windowManager.Mode:new(640, 480, {
	fullscreen = true, fullscreentype = "exclusive",
	vsync = false, msaa = 0,
	resizable = false,
})
windowManager.currentMode = windowMode
keypressed.switchWindowMode = function(key)
	if key == "f11" then
		if windowManager.currentMode ~= windowMode then
			windowManager.currentMode = windowMode
		else
			windowManager.currentMode = fullscreenMode
		end
		mainConfig["enableBackground"]:set(highPerformanceMode.oldBGStatus or mainConfig["enableBackground"]:get())
		windowManager.currentMode:enable()
		love.resize(love.graphics.getWidth(), love.graphics.getHeight())
	elseif key == "f12" then
		if windowManager.currentMode ~= windowMode then
			windowManager.currentMode = windowMode
			mainConfig["enableBackground"]:set(highPerformanceMode.oldBGStatus or mainConfig["enableBackground"]:get())
		else
			windowManager.currentMode = highPerformanceMode
			highPerformanceMode.oldBGStatus = mainConfig["enableBackground"]:get()
			mainConfig["enableBackground"]:set(0)
		end
		windowManager.currentMode:enable()
		love.resize(love.graphics.getWidth(), love.graphics.getHeight())
	end
end





