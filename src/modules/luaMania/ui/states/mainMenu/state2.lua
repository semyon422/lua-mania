local state2 = {}

state2.getBackground = function()
	return {	class = "rectangle",
				w = love.graphics.getWidth(),
				h = love.graphics.getHeight(),
				color = {63, 63, 63}}
end
state2.getButtons = function()
	local radius = 50
	local font = luaMania.graphics.fonts.default
	return {
		[1] = {
			x = love.graphics.getWidth()/2 + 1.1 * radius,
			y = love.graphics.getHeight()/2 - 1.1 * radius,
			r = radius,
			action = function() luaMania.ui.state = "songList" end,
			objects = {
				[2] = {
					{
						class = "circle",
						x = love.graphics.getWidth()/2 + 1.1 * radius,
						y = love.graphics.getHeight()/2 - 1.1 * radius,
						r = radius,
						color = {220, 220, 204},
						type = "line"
					},
					{
						class = "text",
						align = "center",
						y = love.graphics.getHeight()/2 - 1.1 * radius - font.fontsize * (3/4),
						limit = 2 * (love.graphics.getWidth()/2 + 1.1 * radius),
						text = "play",
						color = {223, 196, 125}
					}
				}
			}
		},
		[2] = {
			x = love.graphics.getWidth()/2 + 1.1 * radius * 3,
			y = love.graphics.getHeight()/2 - 1.1 * radius,
			r = radius,
			action = function() print("options") end,
			objects = {
				[2] = {
					{
						class = "circle",
						x = love.graphics.getWidth()/2 + 1.1 * radius * 3,
						y = love.graphics.getHeight()/2 - 1.1 * radius,
						r = radius,
						color = {220, 220, 204},
						type = "line"
					},
					{
						class = "text",
						align = "center",
						y = love.graphics.getHeight()/2 - 1.1 * radius - font.fontsize * (3/4),
						limit = 2 * (love.graphics.getWidth()/2 + 1.1 * radius * 3),
						text = "options",
						color = {223, 196, 125}
					}
				}
			}
		},
		[3] = {
			x = love.graphics.getWidth()/2 + 1.1 * radius,
			y = love.graphics.getHeight()/2 + 1.1 * radius,
			r = radius,
			action = function() print("exit"); love.event.quit() end,
			objects = {
				[2] = {
					{
						class = "circle",
						x = love.graphics.getWidth()/2 + 1.1 * radius,
						y = love.graphics.getHeight()/2 + 1.1 * radius,
						r = radius,
						color = {220, 220, 204},
						type = "line"
					},
					{
						class = "text",
						align = "center",
						y = love.graphics.getHeight()/2 + 1.1 * radius - font.fontsize * (3/4),
						limit = 2 * (love.graphics.getWidth()/2 + 1.1 * radius),
						text = "exit",
						color = {223, 196, 125}
					}
				}
			}
		},
	}
end
state2.actionState = 0
state2.action = function(buttons)
	function love.mousepressed(x, y, button, istouch)
		for buttonIndex, button in pairs(buttons) do
			if (x - button.x)^2 + (y - button.y)^2 <= button.r^2 then
				state2.actionState = 0
				button.action()
			end
		end
	end
	state2.actionState = 1
end

return state2