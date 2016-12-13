local ui = loveio.LoveioObject:new()

ui.classes = require("ui.classes")(ui)
ui.fonts = {
	default = love.graphics.newFont("res/fonts/OpenSans/OpenSansRegular/OpenSansRegular.ttf", 12)
}
ui.accessableGroups = {}

return ui