local ControllerTest = class(Controller)

function ControllerTest:MessagesListening()
	local messages = 
	{
		'ControllerMsgTest',
		'ControllerMsgTest1',
	}
	return messages
end

function ControllerTest:OnReciveMessage(msg,msgBody)
	if msg == 'ControllerMsgTest' then
		Debugger.LogError('ControllerMsgTest Success msgBody  ' .. msgBody)
	elseif msg == 'ControllerMsgTest1' then
		Debugger.LogError('ControllerMsgTest1 Success msgBody  ' .. msgBody)
	end
end

return ControllerTest