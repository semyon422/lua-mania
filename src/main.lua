-- function love.load()
helpers = require("helpers")
Profiler = require("Profiler")
log = helpers.logger.log
	
configManager = require("configManager")
mainConfig = configManager.load("config.txt")
cacheManager = require("cacheManager")

loveio = require("loveio")
pos = loveio.output.Position:new({
	ratios = {0.01, mainConfig["position.ratio"]:get()}, resolutions = {{1, 1}, {1, 1}}
})
objects = {}
loveio.init(objects)

ui = require("ui")

cli = require("cli")

osu = require("osu")
bms = require("bms")
luaMania = require("luaMania")
luaMania.load()

love.graphics.setBackgroundColor(127, 127, 127)
loveio.input.callbacks.keypressed.goFullscreen = function(key)
	if key == "f11" then
		love.window.setFullscreen(not (love.window.getFullscreen()))
	end
end
loveio.input.callbacks.keypressed.printProfilersInfo = function(key)
	if key == "f10" then
		local updateDelta = string.format("%0.2f", loveio.updateProfiler:getDelta())
		local drawDelta = string.format("%0.2f", loveio.drawProfiler:getDelta())
		local globalDelta = drawDelta + updateDelta
		print("profilers: callbacks, upate, draw")
		print("upd: " .. updateDelta .. "ms " .. string.format("%0.2f", updateDelta / globalDelta * 100) .. "%")
		print("drw: " .. drawDelta .. "ms " .. string.format("%0.2f", drawDelta / globalDelta * 100) .. "%")
	end
end
-- end
