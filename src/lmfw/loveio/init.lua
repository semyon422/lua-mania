local loveio = {}

loveio.LoveioObject = require("loveio.LoveioObject")(loveio)

loveio.input = require("loveio.input")(loveio)
loveio.output = require("loveio.output")(loveio)

loveio.init = function(objects)
	loveio.objects = objects or {}
	local objects = loveio.objects
	love.update = function(dt)
		loveio.dt = dt
		for _, object in pairs(objects) do
			if object.update then object:update() end
		end
	end
	
	loveio.globalProfiler = Profiler:new()
	loveio.callbacksProfiler = Profiler:new()
	loveio.updateProfiler = Profiler:new()
	loveio.drawProfiler = Profiler:new()
	love.run = function()
		if love.math then
			love.math.setRandomSeed(os.time())
		end
	 
		if love.load then love.load(arg) end
		if love.timer then love.timer.step() end
	 
		local dt = 0
		while true do
			if love.event then
				love.event.pump()
				for name, a,b,c,d,e,f in love.event.poll() do
					if name == "quit" then
						if not love.quit or not love.quit() then
							return a
						end
					end
					love.handlers[name](a,b,c,d,e,f)
				end
			end
			
			if love.timer then
				love.timer.step()
				dt = love.timer.getDelta()
			end

			loveio.updateProfiler:start()
			if love.update then love.update(dt) end
			loveio.updateProfiler:stop()

			
			loveio.drawProfiler:start()
			if love.graphics and love.graphics.isActive() then
				love.graphics.clear(love.graphics.getBackgroundColor())
				love.graphics.origin()
				if love.draw then love.draw() end
				love.graphics.present()
			end
			loveio.drawProfiler:stop()
	 
			if love.timer then love.timer.sleep(math.max(0, 0.001 - love.timer.getTime())) end
		end
	 
	end
	loveio.input.init()
	loveio.output.init()
end

return loveio