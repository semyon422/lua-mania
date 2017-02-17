local init = function(...)
--------------------------------
local cacheUpdater = loveio.LoveioObject:new()
cacheUpdater.threadSource = [[
	local inChannel = love.thread.getChannel("inChannel")
	local outChannel = love.thread.getChannel("outChannel")
	
	local message = inChannel:pop()
	local status, value = pcall(loadstring(message))
	
	local newList = {}
	local formats = formats or {}
	local path = path or {}
	local counter = 0
	local stop = false
	local lookup
	lookup = function(path)
		if stop then return end
		for _, fileName in pairs(love.filesystem.getDirectoryItems(path)) do
			if love.filesystem.isDirectory(path .. fileName) then
				lookup(path .. fileName .. "/")
			elseif love.filesystem.isFile(path .. fileName) then
				if formats[string.sub(fileName, -3, -1)] then
					newList[path .. fileName] = true
				end
				counter = counter + 1
				if counter % 1000 == 0 then print(counter) end
			end
		end
		if inChannel:pop() == "stop" then stop = true end
	end
	print("check files")
	lookup(path)
	if stop then return end
	print("checked")
	
	local cacheManager = require("src.lmfw.cacheManager")
	local cache = cacheManager.Cache:new():load("mapCache.lua")
	for filePath, _ in pairs(newList) do
		if not cache.list[filePath] then
	        outChannel:push("a" .. filePath)
		end
    end
	for filePath, _ in pairs(cache.list) do
		if not love.filesystem.exists(filePath) then
	        outChannel:push("r" .. filePath)
		end
	end
	outChannel:push("c")
]]



cacheUpdater.load = function(self)
	self.thread = love.thread.newThread(cacheUpdater.threadSource)
	self.inChannel = love.thread.getChannel("inChannel")
	self.outChannel = love.thread.getChannel("outChannel")
	
	self.inChannel:push([[
		path = "res/Songs/"
		formats = {osu = true, bms = true, bme = true, lmx = true}
	]])
	
	self.thread:start()
	
	self.cache = mapCache
end

cacheUpdater.postUpdate = function(self)
	local message = self.outChannel:pop() or ""
	if message == "c" then
		loveio.input.callbacks.quit.saveCaches()
		self:remove()
	elseif message:sub(1, 1) == "a" then
		local object = mapCacheCallback(message:sub(2, -1))
		self.cache:addObject(message:sub(2, -1), object)
	elseif message:sub(1, 1) == "r" then
		self.cache:removeObject(message:sub(2, -1))
	end
	
	local threadError = self.thread:getError()
	if threadError then
		error(threadError)
	end
end

cacheUpdater.unload = function(self)
	if self.thread and self.thread:isRunning() then self.inChannel:push("stop") end
end

return cacheUpdater
--------------------------------
end

return init