
--输出日志--
function log(str)
    Debugger.Log(str);
end

--错误日志--
function logError(str) 
	Debugger.LogError(str);
end

--警告日志--
function logWarn(str) 
	Debugger.LogWarning(str);
end

--输出日志--
function logColor(...)
	str = ""
	for k, v in pairs{...} do
		if type(v) == "string" then
			str = str .. v .. ", "
		else
			str = str .. tostring(v) .. ", "
		end
	end
    Debugger.LogError("<color=yellow>" .. str .. "</color>");
end

function string.split(str, delimiter)
	if str==nil or str=='' or delimiter==nil then
		return nil
	end
	
    local result = {}
    for match in (str..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end

function string.tobyteString(byteTable)
	return string.char(unpack(byteTable))
end

--function arrayContain( array, value, returnIndex)
--	for i=1,#array do
--		if array[i] == value then
--			if returnIndex then
--				return i
--			else
--				return true
--			end
--		end
--	end
--	if returnIndex then
--		return 0
--	else
--		return false
--	end
--end

function arrayContain( array, value)
	for i=1,#array do
		if array[i] == value then
			return true
		end
	end
	return false
end

function file_exists(path)
	local file = io.open(path, "rb")
	if file then file:close() end
	return file ~= nil
end

function length_of_file(filename)
	local fh = assert(io.open(filename, "rb"))
	local len = assert(fh:seek("end"))
	fh:close()
	return len
end