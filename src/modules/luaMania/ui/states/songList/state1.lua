local state1 = {}

state1.getBackground = function()
	return {	class = "rectangle",
				w = love.graphics.getWidth(),
				h = love.graphics.getHeight(),
				color = {63, 63, 63}}
end

--state1.buttonHeight = (lg.getHeight() - 2*lg.getHeight()*data.ui.songlist.height - data.ui.songlist.offset)/5 - data.ui.songlist.offset
state1.buttonHeight = 50
state1.cachePosition = 1

		for i = 1, #luaMania.data.cache do
			if i == state1.cachePosition then
				table.insert(luaMania.graphics.objects[2], {
					class = "text",
					align = "left",
					text = luaMania.data.cache[i].artist .. " - " .. luaMania.data.cache[i].title .. " - " .. luaMania.data.cache[i].version,
					color = {223, 196, 125}
				})
			else
				table.insert(luaMania.graphics.objects[2], {
					class = "text",
					align = "left",
					y = 100,
					text = luaMania.data.cache[i].artist .. " - " .. luaMania.data.cache[i].title .. " - " .. luaMania.data.cache[i].version,
					color = {223, 196, 125}
				})
			end
		end
end

return state1