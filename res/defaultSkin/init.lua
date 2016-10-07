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

return skin
--------------------------------
end

return init