MessageCenter = class()
local dicMsgs = {}
local dicMessageName = {}
local eventid = 0
function MessageCenter.SendMessage(message,...)
    if dicMsgs[message] ~= nil then
        --for i = 1,#dicMsgs[message] do
        --    local func = dicMsgs[message][i]
        --    dicMsgs[message][i](message,...)
        --end

        for k,v in pairs(dicMsgs[message]) do
            v(message,...)
        end
    end
end

function MessageCenter.AddListener(message,func)
    eventid = eventid + 1
    if dicMsgs[message] == nil then
        local funcs = {}
        dicMsgs[message] = funcs
    end
    dicMsgs[message][eventid] = func
    --table.insert(dicMsgs[message],func)
    dicMessageName[eventid] = message
    return eventid
end

function MessageCenter.RemoveListener(id)
    local message = dicMessageName[id]
    if dicMsgs[message] ~= nil then
        --local index = 0
        --for i = 1,#dicMsgs[message] do
        --	if dicMsgs[message][i] == func then
        --		index = i
        --		break
        --	end
        --end
        --if index ~= 0 then
        --	table.remove(dicMsgs[message],index)
        --	if #dicMsgs[message] == 0 then
        --		dicMsgs[message] = nil
        --	end
        --end

        dicMsgs[message][id] = nil
        dicMessageName[id] = nil
    end
end
