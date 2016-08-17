local init = function(luaMania)
--------------------------------
local config = {}

config.qwe = 1
config.wer = {asd = 2}
config.qa = {ws = {ed = "hello"}}

return configManager.toOneDim(config)
--------------------------------
end

return init