local current = {}

current.init = {
	update = function()
		current.background = luaMania.ui.objects.all.background
		current.circle = luaMania.ui.objects.all.circle
		current.logo = luaMania.ui.objects.all.logo
		current.button = luaMania.ui.objects.all.button
		current.button1 = luaMania.ui.objects.all.button1
		current.init = nil
	end
}

return current