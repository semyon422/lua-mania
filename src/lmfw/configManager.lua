local configManager = {}

configManager.Config = {}

configManager.Config.new = function(self)
	local config = {}
	config.data = {}
	
	setmetatable(config, self)
	self.__index = self
	return config
end

configManager.Config.save = function(self, filePath)
	local file = io.open(filePath, "w")
	
	local keyLines = {}
	for key, data in pairs(self.data) do
		keyLines[data.line] = key
	end
	
	out = {}
	for _, key in ipairs(keyLines) do
		local data = self.data[key]
		table.insert(out, key .. " = " .. data.stringValue)
	end
	file:write(table.concat(out, "\n"))
	return self
end

configManager.Config.load = function(self, filePath)
	local file = io.open(filePath, "r")
	
	local lastLineNumber = 0
	for line in file:lines() do
		local breakedLine = explode("=", line)
		if #breakedLine > 1 then
			local key = trim(breakedLine[1])
			table.remove(breakedLine, 1)
			local stringValue = trim(table.concat(breakedLine))
			local status, value = pcall(loadstring("return " .. stringValue))
			if not self.data[key] then
				lastLineNumber = lastLineNumber + 1
			end
			self.data[key] = {line = lastLineNumber}
			self.data[key].stringValue = stringValue
			self.data[key].value = value or stringValue
		end
	end
	return self
end

configManager.Config.get = function(self, key, defaultValue)
	if self.data[key] then
		return self.data[key].value
	else
		return defaultValue
	end
end

configManager.Config.set = function(self, key, value, needLoad)
	self.data[key] = self.data[key] or {}
	local configItem = self.data[key]
	
	configItem.stringValue = tostring(value)
	if needLoad then
		configItem.status, configItem.value = pcall(loadstring("return " .. configItem.stringValue))
	else
		configItem.value = value
	end
	
	return configItem.value
end

return configManager
