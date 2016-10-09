local init = function(...)
--------------------------------
local skin = {}
skin.path = "res/defaultSkin/"

skin.game = {}
skin.game.vsrg = {}
skin.game.vsrg.circle = love.graphics.newImage(skin.path .. "vsrg/circle/3fff9f.png")
skin.game.vsrg.head = love.graphics.newImage(skin.path .. "vsrg/arrow/ffffff.png")
skin.game.vsrg.tail = skin.game.vsrg.head
skin.game.vsrg.body = love.graphics.newImage(skin.path .. "vsrg/hold/ffffff.png")

skin.game.vsrg.columnWidth = 0.1
skin.game.vsrg.columnStart = 0.075
skin.game.vsrg.columnColor = {0, 0, 0, 127}
skin.game.vsrg.hitPosition = 0

return skin
--------------------------------
end

return init