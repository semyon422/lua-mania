local isInBox = function(x, y, bx, by, bw, bh)
	if x >= bx and x <= bx + bw and y >= by and y <= by + bh then
		return true
	end
end

return isInBox