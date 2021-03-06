local keypressed = loveio.input.callbacks.keypressed

--------------------------------
-- Profiler
--------------------------------
keypressed.printProfilersInfo = function(key)
	if key == "f10" then
		local updateDelta = string.format("%0.2f", loveio.updateProfiler:getDelta())
		local drawDelta = string.format("%0.2f", loveio.drawProfiler:getDelta())
		local globalDelta = drawDelta + updateDelta
		print("profilers: callbacks, update, draw; fps = " .. love.timer.getFPS())
		print("upd: " .. updateDelta .. "ms " .. string.format("%0.2f", updateDelta / globalDelta * 100) .. "%")
		print("drw: " .. drawDelta .. "ms " .. string.format("%0.2f", drawDelta / globalDelta * 100) .. "%")
	end
end

--------------------------------
-- Cache
--------------------------------
mapCache.addCallback = function(self, filePath)
	print("a", filePath)
end
mapCache.removeCallback = function(self, filePath)
	print("r", filePath)
end

--------------------------------
-- Cli binds
--------------------------------
mainCli:bind("gameState", function(command)
	local breaked = explode(" ", command)
	if breaked[2] == "set" then
		game.gameState.data.state = breaked[3]
		game.object = temp[breaked[4]]
	end
end)

--------------------------------
-- Window manager settings
--------------------------------
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
		mainConfig:set("enableBackground", highPerformanceMode.oldBGStatus or mainConfig:get("enableBackground", 0))
		windowManager.currentMode:enable()
		love.resize(love.graphics.getWidth(), love.graphics.getHeight())
	elseif key == "f12" then
		if windowManager.currentMode ~= windowMode then
			windowManager.currentMode = windowMode
			mainConfig:set("enableBackground", highPerformanceMode.oldBGStatus or mainConfig:get("enableBackground", 0))
		else
			windowManager.currentMode = highPerformanceMode
			highPerformanceMode.oldBGStatus = mainConfig:get("enableBackground", 0)
			mainConfig:set("enableBackground", 0)
		end
		windowManager.currentMode:enable()
		love.resize(love.graphics.getWidth(), love.graphics.getHeight())
	end
end

--------------------------------
-- Callbacks
--------------------------------
loveio.input.callbacks.quit.saveMainConfig = function()
	mainConfig:save("config.txt")
end
loveio.input.callbacks.quit.saveCaches = function()
	mapCache:save("mapCache.lua")
end

--------------------------------
-- Menu list
--------------------------------
mainMenuList = {
    {
        title = "Play",
        action = function(self)
            self.mapList.state = "songs"
			uiBase.mapList.list = uiBase.mapList:genList(mapCache.list)
            self.mapList:reload()
        end
    },
    {
        title = "Options",
        action = function(self)
            print("options")
        end
    },
    {
        title = "Exit",
        action = function(self)
            love.event.quit()
        end
    }
}

temp = {}
