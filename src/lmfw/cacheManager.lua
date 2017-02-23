local cacheManager = {}

cacheManager.Cache = {}

cacheManager.Cache.new = function(self)
    local cache = {}
	-- cache.newList = {}
	cache.list = {}

    setmetatable(cache, self)
    self.__index = self
    return cache
end

-- cacheManager.Cache.lookupRecursive = function(self, path)
	-- for _, fileName in pairs(love.filesystem.getDirectoryItems(path)) do
		-- if love.filesystem.isDirectory(path .. fileName) then
			-- self:lookup(path .. fileName .. "/", self.newList)
		-- elseif love.filesystem.isFile(path .. fileName) then
			-- if self.rules.formats[string.sub(fileName, -3, -1)] then
				-- self.newList[path .. fileName] = true
			-- end
		-- end
	-- end
-- end

-- cacheManager.Cache.lookup = function(self, path)
	-- for _, fileName in pairs(love.filesystem.getDirectoryItems(path)) do
		-- if love.filesystem.isDirectory(path .. fileName) then
			-- self.newList[path .. fileName] = true
		-- elseif love.filesystem.isFile(path .. fileName) then
			-- if self.rules.formats["any"] or self.rules.formats[string.sub(fileName, -3, -1)] then
				-- self.newList[path .. fileName] = true
			-- end
		-- end
	-- end
-- end

-- cacheManager.Cache.update = function(self, rules)
	-- self.rules = rules or {}
	-- self.rules.path = self.rules.path or ""
	-- self.rules.formats = self.rules.formats or {any = true}
	-- self.rules.callback = self.rules.callback or function(filePath) return {title = filePath} end
	
	-- print(string.rep("-", 64))
	-- print("updating cache:")
	-- print("  generating fileList...")
	-- self.newList = {}
    -- self:lookup(self.rules.path)
	-- print("    complete!")
	-- print("  checking for new maps...")
	-- local counterNew = 0
    -- for filePath, _ in pairs(self.newList) do
		-- if not self.list[filePath] then
	        -- local object = self.rules.callback(filePath)
	        -- if object then
				-- self.list[filePath] = object
				-- counterNew = counterNew + 1
				-- print("      added:", object.title)
	        -- end
		-- end
    -- end
	-- print("    complete! loaded " .. counterNew .. " objects.")
	-- print("  cleaning cache...")
	-- local counterOld = 0
	-- for filePath, _ in pairs(self.list) do
		-- if not love.filesystem.exists(filePath)
		-- and (string.sub(filePath, 1, string.len(self.rules.path)) == self.rules.path)
		-- and not string.find(string.sub(filePath, string.len(self.rules.path) + 1, -1), "/") then
			-- self.list[filePath] = nil
			-- counterOld = counterOld + 1
			-- print("      removed:", filePath)
		-- end
	-- end
	-- print("    complete! removed " .. counterOld .. " objects.")
	-- print(string.rep("-", 64))
-- end

cacheManager.Cache.addObject = function(self, filePath, object)
	self.list[filePath] = object
	if self.addCallback then self:addCallback(filePath) end
end
cacheManager.Cache.removeObject = function(self, filePath)
	self.list[filePath] = nil
	if self.removeCallback then self:removeCallback(filePath) end
end

cacheManager.Cache.save = function(self, filePath)
	local file = io.open(filePath, "w")
	
	file:write("local cache = {}\n\n")
	for filePath, object in pairs(self.list) do
		file:write("cache[\"" .. filePath .. "\"]\t= ")
		file:write(table2string(object))
	end
	file:write("\n")
	file:write("return cache")
end

cacheManager.Cache.load = function(self, filePath)
	print(string.rep("-", 64))
	io.write("loading cache: " .. filePath .. " ... ")
	-- print("  reading " .. filePath)
	local status, cache = pcall(loadfile(filePath))

	self.list = {}
	
	if status and cache then
		local counter = 0
		for filePath, object in pairs(cache) do
			self.list[filePath] = object
			counter = counter + 1
		end
		print("complete, " .. counter .. " loaded")
	else
		print("error, created new cache")
	end
	print(string.rep("-", 64))
	
	return self
end

return cacheManager
