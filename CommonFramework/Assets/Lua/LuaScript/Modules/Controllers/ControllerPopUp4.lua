local ControllerPopUp4 = class(Controller)

function ControllerPopUp4:ctor()
	
end

function ControllerPopUp4:MessagesListening()
	local messages = 
	{
		--MessageNames.OpenUILogin,
	}
	return messages
end

function ControllerPopUp4:OnReciveMessage(msg,msgBody)
	-- if msg == MessageNames.OpenUILogin then
		
	-- elseif msg == MessageNames.XXXX then
		
	-- end
end

return ControllerPopUp4