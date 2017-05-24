local ControllerTop1 = class(Controller)

function ControllerTop1:ctor()
	
end

function ControllerTop1:MessagesListening()
	local messages = 
	{
		MessageNames.OpenUITop1,
	}
	return messages
end

function ControllerTop1:OnReciveMessage(msg,msgBody)
	if msg == MessageNames.OpenUITop1 then
		self:ShowTop1()
	end
end

function ControllerTop1:ShowTop1()
	if self.top1view == nil then
		self.top1view = self:GetView('ViewUITop1')
		
	end
	self.top1view:Show()
end

return ControllerTop1