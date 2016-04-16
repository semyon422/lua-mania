local ui = {}

ui.input = require("ui.input") -- keyBinds, mouseBinds (pairs)
ui.output = require("ui.output") -- objects (ipairs)

ui.objects = {
	all = {},
	current = {}
}

ui.update = function()
	for _, object in pairs(ui.objects.current) do
		object.update()
	end
end

--[[
keyBind = {
	press(key)
	release(key)
}
mouseBind = {
	press(x, y, button)
	move(x, y, button)
	release(x, y, button)
	wheel(x, y)
}
]]

return ui