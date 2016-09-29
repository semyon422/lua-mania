local init = function(cli)
--------------------------------
local Cli = {}

Cli.new = function(self, cli)
	local cli = cli or {}
	cli.binds = cli.binds or {}
	cli.out = cli.out or {}
	
	setmetatable(cli, self)
	self.__index = self
	return cli
end

Cli.bind = function(self, commandName, bindFunction)
	self.binds[commandName] = bindFunction
end

Cli.run = function(self, command)
	local breaked = explode(" ", command)
	local commandName = breaked[1]
	local out = ""
	
	if self.binds[commandName] then
		out = self.binds[commandName](command)
	else
		out = "unknown command"
	end
	self:print(out)
	return out
end

Cli.print = function(self, outString)
	table.insert(self.out, outString)
end

Cli.read = function(self, stringNumber)
	return self.out[#self.out - (stringNumber - 1)] or ""
end

return Cli
--------------------------------
end

return init