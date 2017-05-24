local ControllerPopUp3 = class(Controller)

function ControllerPopUp3:ctor()
	
end

function ControllerPopUp3:MessagesListening()
	local messages = 
	{
		--MessageNames.OpenUILogin,
	}
	return messages
end

function ControllerPopUp3:OnReciveMessage(msg,msgBody)
	-- if msg == MessageNames.OpenUILogin then
		
	-- elseif msg == MessageNames.XXXX then
		
	-- end
end

return ControllerPopUp3