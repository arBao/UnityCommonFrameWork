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
		self.top1view.onClickButtonConfirmCallback = function ()
			self:SendMessage(MessageNames.OpenUITop2,nil)
		end
		self.top1view.onClickButtonLoadSceneCallback = function ()
            local funcProgress = function (operation)
                Debugger.LogError(operation.progress)
            end
            SceneMgr.LoadASyny('Scene1',funcProgress)
		end
	end
	self.top1view:Show()
end

return ControllerTop1