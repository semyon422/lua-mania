local state1 = {}

state1.getBackground = function()
	return {	class = "rectangle",
				w = love.graphics.getWidth(),
				h = love.graphics.getHeight(),
				color = {63, 63, 63}}
end
state1.getButtons = function()
	local radius = 100
	local font = luaMania.graphics.fonts.logo
	return {
		[1] = {
			x = love.graphics.getWidth() / 2,
			y = love.graphics.getHeight() / 2,
			r = radius,
			action = function() luaMania.ui.states.mainMenu.state = 2 end,
			objects = {
				[2] = {
					{
						class = "circle",
						x = love.graphics.getWidth() / 2,
						y = love.graphics.getHeight() / 2,
						r = radius,
						color = {220, 220, 204},
						type = "line"
					},
					{
						class = "text",
						align = "center",
						y = love.graphics.getHeight() / 2 - font.fontsize * (3/4),
						text = "lua-mania",
						color = {223, 196, 125}
					}
				}
			}
		}
	}
end
state1.actionState = 0
state1.action = function(buttons)
	function love.mousepressed(x, y, button, istouch)
		for buttonIndex, button in pairs(buttons) do
			if (x - button.x)^2 + (y - button.y)^2 <= button.r^2 then
				state1.actionState = 0
				button.action()
			end
		end
	end
	state1.actionState = 1
end

return state1