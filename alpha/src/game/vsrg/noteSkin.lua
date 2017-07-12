game.VSRG.noteSkin = createClass()
local noteSkin = game.VSRG.noteSkin

noteSkin.cs = soul.CS:new()

noteSkin.note = love.graphics.newImage("res/noteSkin/note.png")
noteSkin.holdBody = love.graphics.newImage("res/noteSkin/holdBody.png")
noteSkin.holdHead = love.graphics.newImage("res/noteSkin/holdHead.png")
noteSkin.holdTail = love.graphics.newImage("res/noteSkin/holdTail.png")

noteSkin.columnStart = 0
noteSkin.columnWidth = 0.1

noteSkin.get = function(self, data)
	if data.key == "note" then
		return noteSkin.note
	elseif data.key == "holdBody" then
		return noteSkin.note
	elseif data.key == "holdHead" then
		return noteSkin.holdHead
	elseif data.key == "holdTail" then
		return noteSkin.holdTail
	elseif data.key == "x" then
		return noteSkin.columnStart +
			noteSkin.columnWidth * (data.index - 1)
	elseif data.key == "columnWidth" then
		return noteSkin.columnWidth
	end
end

