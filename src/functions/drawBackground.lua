--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
local function drawBackground(self)
	local background = data.skin.sprites.background
	local backgroundDarkness = data.config.backgroundDarkness
	local skin = data.skin
	
	if skin.config.background.draw then
		scale = 1
		if data.width < background:getWidth() * scale then
			-- nothing
		end
		if data.height < background:getHeight() * scale then
			scale = data.height / background:getHeight()
		end
		if data.width > background:getWidth() * scale then
			scale = data.width / background:getWidth()
		end
		if data.height > background:getHeight() * scale then
			scale = data.height / background:getHeight()
		end

		lg.draw(background, data.width / 2, data.height / 2, 0, scale, scale, background:getWidth() / 2, background:getHeight() / 2)
		
		lg.setColor(0, 0, 0, (backgroundDarkness / 100) * 255)
		lg.rectangle("fill", 0, 0, data.width, data.height)
		lg.setColor(255, 255, 255, 255)
	end
end

return drawBackground