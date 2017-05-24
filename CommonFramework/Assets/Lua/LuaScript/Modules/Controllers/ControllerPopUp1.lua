local ControllerPopUp1 = class(Controller)

function ControllerPopUp1:ctor()
	
end

function ControllerPopUp1:MessagesListening()
	local messages = 
	{
		MessageNames.OpenUIPopUp1,
	}
	return messages
end

function ControllerPopUp1:OnReciveMessage(msg,msgBody)
	if msg == MessageNames.OpenUIPopUp1 then
		self:ShowPopupView()
	end
end

function ControllerPopUp1:ShowPopupView()
	if self.popupview == nil then
		self.popupview = self:GetView('ViewUIPopUp1')
		self.popupview.onClickButtonConfirmCallback = function ()
			self:SendMessage(MessageNames.OpenUITop1,nil)
		end
	end
	self.popupview:Show()
end

return ControllerPopUp1