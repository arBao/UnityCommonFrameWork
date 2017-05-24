local ControllerTop2 = class(Controller)

function ControllerTop2:ctor()
	
end

function ControllerTop2:MessagesListening()
	local messages = 
	{
		MessageNames.OpenUITop2,
	}
	return messages
end

function ControllerTop2:OnReciveMessage(msg,msgBody)
	if msg == MessageNames.OpenUITop2 then
		self:ShowTop2()
	end
end

function ControllerTop2:ShowTop2()
	if self.top2view == nil then
		self.top2view = self:GetView('ViewUITop2')
		
	end
	self.top2view:Show()
end

return ControllerTop2