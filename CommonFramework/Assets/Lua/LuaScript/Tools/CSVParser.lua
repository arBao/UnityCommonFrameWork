CSVParser = class()
local csvDataCache = {}
local csvHeaderCache = {}
function CSVParser.LoadCsv(path,key)
	local csvCache = csvDataCache[path]
	if 	csvCache ~= nil then
		local csvLineCache = csvCache[key]
		if csvLineCache ~= nil then
			return csvLineCache
		end
	else
		csvDataCache[path] = {}
		local textAsset = AssetsManager.Instance:GetAsset(path,typeof(UnityEngine.TextAsset)) 
		local csvLines = string.split(textAsset.text,'\n')
		local headers = {}
		for i = 1, #csvLines do
			local csvLine = v
			local csvData = string.split(csvLines[i],',')
			if i == 1 then
				headers = csvData
				csvHeaderCache[path] = csvLine
			else
				if csvDataCache[path][key] == nil then
					csvDataCache[path][key] = {}
				end
				for j = 1,#headers do
					csvDataCache[path][key][headers[j]] = csvData[j]
				end
			end
		end
	end
	
	if csvDataCache[path][key] == nil then
		Debugger.LogError('不存在 path = ' .. path .. '    key = ' .. key .. '的配置')
	end
	return csvDataCache[path][key]
end