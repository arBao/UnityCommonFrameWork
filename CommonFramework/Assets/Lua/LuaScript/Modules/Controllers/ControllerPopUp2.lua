local ControllerPopUp2 = class(Controller)

function ControllerPopUp2:ctor()
	
end

function ControllerPopUp2:MessagesListening()
	local messages = 
	{
		--MessageNames.OpenUILogin,
	}
	return messages
end

function ControllerPopUp2:OnReciveMessage(msg,msgBody)
	-- if msg == MessageNames.OpenUILogin then
		
	-- elseif msg == MessageNames.XXXX then
		
	-- end
end

return ControllerPopUp2