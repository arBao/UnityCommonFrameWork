local ControllerPopUp3 = class(Controller)

function ControllerPopUp3:ctor()
	
end

function ControllerPopUp3:MessagesListening()
	local messages = 
	{
		MessageNames.OpenUIPopUp3,
	}
	return messages
end

function ControllerPopUp3:OnReciveMessage(msg,msgBody)
	if msg == MessageNames.OpenUIPopUp3 then
		self:ShowPopupView()
	end
end

function ControllerPopUp3:ShowPopupView()
	if self.popupview == nil then
		self.popupview = self:GetView('ViewUIPopUp3')
		self.popupview.onClickButtonConfirmCallback = function ()
			self:SendMessage(MessageNames.OpenUIPopUp4,nil)
		end
	end
	self.popupview:Show()
end

return ControllerPopUp3