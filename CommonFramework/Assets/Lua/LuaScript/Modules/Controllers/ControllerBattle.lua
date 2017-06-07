local ControllerBattle = class(Controller)

function ControllerBattle:ctor()
	
end

function ControllerBattle:MessagesListening()
	local messages = 
	{
		MessageNames.OpenUIBattle,
	}
	return messages
end

function ControllerBattle:OnReciveMessage(msg,msgBody)
	if msg == MessageNames.OpenUIBattle then
		self:ShowUIBattle()
	end
end

function ControllerBattle:ShowUIBattle()
	if self.battleview == nil then
		self.battleview = self:GetView('ViewUIBattle')
		self.battleview.onClickButtonSpeedCallback = function ()

		end
        self.battleview.JoyStickOnDragCallback = function(direction)
            Debugger.LogError("direction.x   " .. direction.x .. '  direction.y  ' .. direction.y)
        end
        self.battleview.JoyStickEndDragCallback = function()
            Debugger.LogError('EndDragCallback')
        end

	end
	self.battleview:Show()
end

return ControllerBattle