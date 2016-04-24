local modes = {}

modes.current = "mania"
modes.mania = require("luaMania.modes.mania")

modes.update = function()
	--modes[modes.current].update()
end

return modes