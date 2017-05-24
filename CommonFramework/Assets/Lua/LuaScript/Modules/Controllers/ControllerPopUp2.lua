local ControllerPopUp2 = class(Controller)

function ControllerPopUp2:ctor()
	
end

function ControllerPopUp2:MessagesListening()
	local messages = 
	{
		MessageNames.OpenUIPopUp2,
	}
	return messages
end

function ControllerPopUp2:OnReciveMessage(msg,msgBody)
	if msg == MessageNames.OpenUIPopUp2 then
		self:ShowPopupView()
	end
end

function ControllerPopUp2:ShowPopupView()
	if self.popupview == nil then
		self.popupview = self:GetView('ViewUIPopUp2')
		self.popupview.onClickButtonConfirmCallback = function ()
			self:SendMessage(MessageNames.OpenUITop1,nil)
		end
	end
	self.popupview:Show()
end

return ControllerPopUp2