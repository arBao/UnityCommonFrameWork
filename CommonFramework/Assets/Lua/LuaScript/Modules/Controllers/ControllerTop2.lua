local ControllerTop2 = class(Controller)

function ControllerTop2:ctor()
	
end

function ControllerTop2:MessagesListening()
	local messages = 
	{
		--MessageNames.OpenUILogin,
	}
	return messages
end

function ControllerTop2:OnReciveMessage(msg,msgBody)
	-- if msg == MessageNames.OpenUILogin then
		
	-- elseif msg == MessageNames.XXXX then
		
	-- end
end

return ControllerTop2