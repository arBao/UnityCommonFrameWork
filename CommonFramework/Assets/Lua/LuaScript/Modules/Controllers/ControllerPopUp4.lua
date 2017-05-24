local ControllerPopUp4 = class(Controller)

function ControllerPopUp4:ctor()
	
end

function ControllerPopUp4:MessagesListening()
	local messages = 
	{
		MessageNames.OpenUIPopUp4,
	}
	return messages
end

function ControllerPopUp4:OnReciveMessage(msg,msgBody)
	if msg == MessageNames.OpenUIPopUp4 then
		self:ShowPopupView()
	end
end

function ControllerPopUp4:ShowPopupView()
	if self.popupview == nil then
		self.popupview = self:GetView('ViewUIPopUp4')
		self.popupview.onClickButtonConfirmCallback = function ()
			self:SendMessage(MessageNames.OpenUITop1,nil)
		end
	end
	self.popupview:Show()
end

return ControllerPopUp4