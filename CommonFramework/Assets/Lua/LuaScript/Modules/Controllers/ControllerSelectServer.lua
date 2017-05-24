local ControllerSelectServer = class(Controller)

function ControllerSelectServer:ctor()
	
end

function ControllerSelectServer:MessagesListening()
	local messages = 
	{
		MessageNames.OpenUISelectServer,
	}
	return messages
end

function ControllerSelectServer:OnReciveMessage(msg,msgBody)
	if msg == MessageNames.OpenUISelectServer then
		self:ShowSelectServerView()
	end
end

function ControllerSelectServer:ShowSelectServerView()
	if self.selectServerView == nil then
		self.selectServerView = self:GetView('ViewUISelectServer')
		self.selectServerView.onclickBtnConfirmCallback = function ( )
			print('111111111')
			self:SendMessage(MessageNames.OpenUIPopUp1,nil)
		end
	end
		
	self.selectServerView:Show()
end

return ControllerSelectServer