local function generateCache(self)
	local cd = ""
	for out in io.popen("echo %CD%"):lines() do
		cd = out
		break
	end
	for file in io.popen("dir /B /S /OD /A-D res\\Songs"):lines() do
		if #explode(".lm", tostring(file)) == 2 then
			table.insert(data.BMFList, {tostring(explode("\\", explode(cd .. "\\res\\Songs\\", file)[2])[1]), tostring(explode("\\", explode(cd .. "\\res\\Songs\\", file)[2])[2])})
		end
	end
end

return generateCache