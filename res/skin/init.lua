local init = function(luaMania)
--------------------------------
local skin = {}

skin.path = luaMania.config["skinPath"].value

skin.Note = require(skin.path .. "Note")(skin, luaMania)
skin.Hold = require(skin.path .. "Hold")(skin, luaMania)

skin.old = {}

skin.load = function()
	skin.old["luaMania.game.modes.vsrg.Note.drawLoad"] = luaMania.game.modes.vsrg.Note.drawLoad
	luaMania.game.modes.vsrg.Note.drawLoad = skin.Note.drawLoad
	
	skin.old["luaMania.game.modes.vsrg.Hold.drawLoad"] = luaMania.game.modes.vsrg.Hold.drawLoad
	skin.old["luaMania.game.modes.vsrg.Hold.drawUpdate"] = luaMania.game.modes.vsrg.Hold.drawUpdate
	luaMania.game.modes.vsrg.Hold.drawLoad = skin.Hold.drawLoad
	luaMania.game.modes.vsrg.Hold.drawUpdate = skin.Hold.drawUpdate

	skin.loaded = true
end

skin.unload = function()
	luaMania.game.modes.vsrg.Note.drawLoad = skin.old["luaMania.game.modes.vsrg.Note.drawLoad"]
	
	luaMania.game.modes.vsrg.Hold.drawLoad = skin.old["luaMania.game.modes.vsrg.Hold.drawLoad"]
	luaMania.game.modes.vsrg.Hold.drawUpdate = skin.old["luaMania.game.modes.vsrg.Hold.drawUpdate"]
	skin.loaded = false
end

return skin
--------------------------------
end

return init