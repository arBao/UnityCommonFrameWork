local ControllerTemplet = class(Controller)

function ControllerTemplet:ctor()
	
end

function ControllerTemplet:MessagesListening()
	local messages = 
	{
		--MessageNames.OpenUILogin,
	}
	return messages
end

function ControllerTemplet:OnReciveMessage(msg,msgBody)
	-- if msg == MessageNames.OpenUILogin then
		
	-- elseif msg == MessageNames.XXXX then
		
	-- end
end

return ControllerTemplet