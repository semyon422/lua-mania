local init = function(ui)
--------------------------------
local classes = {}

classes.UiObject = require("ui.classes.UiObject")(classes, ui)
classes.Button = require("ui.classes.Button")(classes, ui)
classes.Slider = require("ui.classes.Slider")(classes, ui)
classes.Picture = require("ui.classes.Picture")(classes, ui)

return classes
--------------------------------
end

return init