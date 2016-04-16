local current = {}

current.init = {
	update = function()
		current.background = luaMania.ui.objects.all.background
		current.circle = luaMania.ui.objects.all.circle
		current.logo = luaMania.ui.objects.all.logo
		current.init = nil
	end
}

return current