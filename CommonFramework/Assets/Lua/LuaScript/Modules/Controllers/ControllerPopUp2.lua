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
			self:SendMessage(MessageNames.OpenUISelectServer,nil)
		end
        self.popupview.onClickButtonLoadSceneCallback = function ()
            local funcProgress = function (operation)
                Debugger.LogError(operation.progress)
            end
            local finishCallback = function ()
                self:SendMessage(MessageNames.OpenUISelectServer,nil)
            end
            SceneMgr.LoadASyny('Scene1',funcProgress,finishCallback,false)
        end
	end
	self.popupview:Show()
end

return ControllerPopUp2