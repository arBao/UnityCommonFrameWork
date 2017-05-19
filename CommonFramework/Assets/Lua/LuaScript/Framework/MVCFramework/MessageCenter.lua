MessageCenter = class()
local dicMsgs = {}
function MessageCenter.SendMessage(message,msgBody)
	if dicMsgs[message] ~= nil then
		for i = 1,#dicMsgs[message] do
			local func = dicMsgs[message][i]
			dicMsgs[message][i](message,msgBody)
		end
	end
end

function MessageCenter.AddListener(message,func)
	if dicMsgs[message] == nil then
		local funcs = {}
		dicMsgs[message] = funcs
	end
	table.insert(dicMsgs[message],func)
	return func
end

function MessageCenter.RemoveListener(message,func)
	if dicMsgs[message] ~= nil then
		local index = 0
		for i = 1,#dicMsgs[message] do
			if dicMsgs[message][i] == func then
				index = i
				break
			end
		end
		if index ~= 0 then
			table.remove(dicMsgs[message],index)
			if #dicMsgs[message] == 0 then
				dicMsgs[message] = nil
			end
		end
	end
	return func
end
