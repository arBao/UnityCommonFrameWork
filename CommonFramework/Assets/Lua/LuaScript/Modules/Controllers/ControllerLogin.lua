local ControllerLogin = class(Controller)

function ControllerLogin:MessagesListening()
	local messages = 
	{
		MessageNames.OpenUILogin,
	}
	return messages
end

function ControllerLogin:OnReciveMessage(msg,msgBody)
	if msg == MessageNames.OpenUILogin then
		Debugger.LogError('MessageNames.OpenUILogin ' .. msgBody)
		self.loginView = self:GetView('UILogin')
		self.loginView:Show()
	elseif msg == '111' then
		Debugger.LogError('111 ' .. msgBody)
	end
end

return ControllerLogin