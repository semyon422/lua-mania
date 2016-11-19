local init = function(game, luaMania)
--------------------------------
local lmx = loveio.LoveioObject:new()

lmx.path = game.path .. "modes/lmx/"

lmx.load = function(self)
end

lmx.postUpdate = function(self)
	print("postUpdate")
end

lmx.unload = function(self)
end

return lmx
--------------------------------
end

return init