local cacheManager = {}

cacheManager.Cache = {}

cacheManager.Cache.new = function(self)
    local cache = {}
	cache.newList = {}
	cache.list = {}
	cache.objects = {}

    setmetatable(cache, self)
    self.__index = self
    return cache
end

cacheManager.Cache.lookup = function(self, path)
	for _, fileName in pairs(love.filesystem.getDirectoryItems(path)) do
		if love.filesystem.isDirectory(path .. fileName) then
			self:lookup(path .. fileName .. "/", self.newList)
		elseif love.filesystem.isFile(path .. fileName) then
			local fileType = string.sub(fileName, -3, -1)
			if self.rules.formats[fileType] then
				self.newList[path .. fileName] = true
			end
		end
	end
end

cacheManager.Cache.update = function(self, rules)
	self.rules = rules or {}
    local path = self.rules.path or "."
    local sort = self.rules.sort
    local callback = self.rules.callback or function(filePath) return {filePath = filePath} end
	
	print("updating cache:")
	print("  generating fileList...")
	self.newList = {}
    self:lookup(path)
	print("    complete!")
	print("  checking for new maps...")
	local counterNew = 0
    for filePath, _ in pairs(self.newList) do
		if not self.list[filePath] then
	        local object = callback(filePath)
	        if object then
	            object.type = "cacheItem"
	            self.objects[tostring(object)] = object
				self.list[filePath] = object
				counterNew = counterNew + 1
				print("      added:", object.title)
	        end
		end
    end
	print("    complete! loaded " .. counterNew .. " objects.")
	print("  cleaning cache...")
	local counterOld = 0
	for filePath, _ in pairs(self.list) do
		if not love.filesystem.exists(filePath) then
			local object = self.objects[tostring(self.list[filePath])]
			if object then
				self.objects[tostring(self.list[filePath])] = nil
				self.list[filePath] = nil
				counterOld = counterOld + 1
				print("      removed:", object.title)
			end
		end
	end
	print("    complete! removed " .. counterOld .. " objects.")
end

--[[ --old
cacheManager.Cache.generate = function(self, rules)
	local rules = rules or {}
	local path = rules.path or "."
	local sort = rules.sort
	local callback = rules.callback or function(filePath) return {filePath = filePath} end
	
	self.objects = {}
	self.newList = {}
	self:lookup(path)
	self.list = self.newList
	for filePath, _ in pairs(self.list) do
		local object = callback(filePath)
		if object then
			object.type = "cacheItem"
			table.insert(self.objects, object)
			object.cacheIndex = #self.objects
			self.list[filePath] = object
		end
	end
	if sort then table.sort(self.objects, sort) end
end
]]

cacheManager.Cache.save = function(self, filePath)
	local file = io.open(filePath, "w")
	
	file:write("local cache = {}\n")
	for index, object in pairs(self.objects) do
		file:write("cache[#cache + 1] = {")
		for key, value in pairs(object) do
			if type(value) == "string" or type(value) == "number" then
				file:write(key .. " = " .. string.format("%q", value) .. ", ")
			end
		end
		file:write("}\n")
	end
	file:write("return cache")
end

cacheManager.Cache.load = function(self, filePath)
	print("loading cache:")
	print("  reading " .. filePath)
	local status, cache = pcall(loadfile(filePath))

	self.list = {}
	self.objects = {}
	
	local counter = 0
	if status then
		for _, object in pairs(cache) do
			self.objects[tostring(object)] = object
			self.list[object.filePath] = object
			counter = counter + 1
		end
	end
	print("    complete! loaded " .. counter .. " objects.")
	
	return self
end

return cacheManager
