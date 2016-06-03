local logger = {}

logger.config = {
	filePaths = {"stdout", "log.txt"},
	files = {}
}
logger.log = function(text)
	local out = os.date() .. " " .. text .. "\n"
	for filePathIndex, filePath in pairs(logger.config.filePaths) do
		if filePath == "stdout" then
			io.write(out)
		else
			if not logger.config.files[filePathIndex] then
				logger.config.files[filePathIndex] = io.open(filePath, "w+")
			end
			local file = logger.config.files[filePathIndex]
			file:write(out)
		end
	end
end

return logger