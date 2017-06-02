local ControllerLogin = class(Controller)
function ControllerLogin:ctor()
	self.loginView = nil
	Debugger.LogError('ControllerLogin:ctor')
end

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
		self:ShowUILogin()
	elseif msg == '111' then
		Debugger.LogError('111 ' .. msgBody)
	end
end

function ControllerLogin:ShowUILogin()
	if self.loginView == nil then
		self.loginView = self:GetView('ViewUILogin')
		self.loginView.OnClickButtonLoginCallback = function ( )
			self:SendMessage(MessageNames.OpenUIPopUp1,nil)
		end
        UDPServer.Instance:ReceiveMsg()
		self.loginView.OnClickButtonSendCallback = function ()
            local datasend = {}
            table.insert(datasend,1)
            table.insert(datasend,2)
            table.insert(datasend,3)
            table.insert(datasend,4)
            UDPServer.Instance:SendUDPMsg(string.tobyteString(datasend), 1)
		end
	end
	self.loginView:Show()
	
end

return ControllerLogin