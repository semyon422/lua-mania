local function getBeatmapFileList(self)
	local path = "res/Songs"
	for _,folder in pairs(love.filesystem.getDirectoryItems(path)) do
		if love.filesystem.isDirectory(path .. "/" .. folder) then
			for _,file in pairs(love.filesystem.getDirectoryItems(path .. "/" .. folder)) do
				if love.filesystem.isFile(path .. "/" .. folder .. "/" .. file) then
					if string.sub(file, -4, -1) == ".osu" then
						table.insert(data.BMFList, {folder, file})
					end
				end
			end
		end
	end
end

return getBeatmapFileList