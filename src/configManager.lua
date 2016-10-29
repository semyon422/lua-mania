local configManager = {}

configManager.configItem = {}
configManager.configItem.new = function(self, item)
	local item = item or {}
	setmetatable(item, self)
	self.__index = self
	return item
end
configManager.configItem.set = function(self, value, needLoad)
	self.stringValue = tostring(value)
	if needLoad then
		self.status, self.value = pcall(loadstring("return " .. self.stringValue))
	else
		self.value = value
	end
	return self
end
configManager.configItem.get = function(self)
	return self.value
end

configManager.save = function(config, filePath)
	local file = io.open(filePath, "w")
	
	local keyLines = {}
	for key, data in pairs(config) do
		keyLines[data.line] = key
	end
	
	outString = ""
	for _, key in ipairs(keyLines) do
		local data = config[key]
		outString = outString .. key .. " = " .. data.stringValue .. "\n"
	end
	file:write(outString)
end

configManager.load = function(filePath)
	local file = io.open(filePath, "r")
	local config = {}
	
	local lastLineNumber = 0
	for line in file:lines() do
		local breakedLine = explode("=", line)
		if #breakedLine > 1 then
			local key = trim(breakedLine[1])
			table.remove(breakedLine, 1)
			local stringValue = trim(table.concat(breakedLine))
			local status, value = pcall(loadstring("return " .. stringValue))
			if not config[key] then
				lastLineNumber = lastLineNumber + 1
			end
			config[key] = configManager.configItem:new({line = lastLineNumber})
			config[key]:set(value or stringValue)
		end
	end
	return config
end

configManager.toConfig = function(config)
	if not config then return end
	local newConfig = {}
	
	for configKey, configValue in pairs(config) do
		newConfig[configKey] = configManager.configItem:new():set(configValue)
	end

	return newConfig
end

-- configManager.toOneDim = function(config)
	-- if not config then return end
	-- local newConfig = {}
	-- local lookup
	-- lookup = function(configTable, prefix)
		-- for configKey, configValue in pairs(configTable) do
			-- if type(configValue) == "table" then
				-- lookup(configValue, prefix .. configKey .. ".")
			-- else
				-- newConfig[prefix .. configKey] = configManager.configItem:new():set(configValue)
			-- end
		-- end
		-- return list
	-- end

	-- lookup(config, "")
	
	-- return newConfig
-- end

return configManager
