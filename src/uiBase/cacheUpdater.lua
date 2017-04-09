local init = function(...)
--------------------------------
local cacheUpdater = loveio.LoveioObject:new()
cacheUpdater.threadSource = [[
	require("packagePath")
	explode = require("explode")
	trim = require("trim")
	startsWith = require("startsWith")
	utf8validate = require("utf8validate")
	table2string = require("table2string")
	cacheManager = require("cacheManager")
	require("rglib")
	
	local inChannel = love.thread.getChannel("inChannel")
	local outChannel = love.thread.getChannel("outChannel")
	
	-- local message = inChannel:pop()
	-- local status, value = pcall(loadstring(message))
	
	local newList = {}
	local formats = {osu = true, bms = true, bme = true, lmx = true, lmp = true, lmn = true}
	local path = "res/Songs/"
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
	
	local mapCacheCallback = function(filePath)
		local fileType = string.sub(filePath, -3, -1)
		if fileType == "osu" then
			return osu.Beatmap.genCache(filePath)
		elseif fileType == "bms" or fileType == "bme" then
			return bms.Beatmap.genCache(filePath)
		elseif fileType == "lmx" then
			return lmx.Beatmap.genCache(filePath)
		elseif fileType == "lmp" then
			return lmp.Beatmap.genCache(filePath)
		elseif fileType == "lmn" then
			return lmn.Beatmap.genCache(filePath)
		end
	end
	
	local cache = cacheManager.Cache:new():load("mapCache.lua")
	for filePath, _ in pairs(newList) do
		if not cache.list[filePath] then
	        outChannel:push("a" .. table2string(mapCacheCallback(filePath)))
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
	
	-- self.inChannel:push([[
		-- path = "res/Songs/"
		-- formats = {osu = true, bms = true, bme = true, lmx = true, lmp = true}
	-- ]])
	
	self.thread:start()
	
	self.cache = mapCache
end

cacheUpdater.postUpdate = function(self)
	local message = self.outChannel:pop() or ""
	if message == "c" then
		loveio.input.callbacks.quit.saveCaches()
		self:remove()
	elseif message:sub(1, 1) == "a" then
		local status, object = pcall(loadstring("return " .. message:sub(2, -1)))
		if status and object and object.filePath then
			self.cache:addObject(object.filePath, object)
		end
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
