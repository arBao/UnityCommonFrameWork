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
			self:SendMessage(MessageNames.OpenUIPopUp3,nil)
		end

		self.selectServerView.onClickBackCallback = function ( )
            local progressAction = function (operation)

            end
            local loadSceneFinish = function ()
                Debugger.LogError('1111111')
                self.selectServerView:Hide()
            end
            SceneMgr.LoadASyny('Scene2',progressAction, loadSceneFinish,true)
		end
	end
		
	self.selectServerView:Show()
end

return ControllerSelectServer