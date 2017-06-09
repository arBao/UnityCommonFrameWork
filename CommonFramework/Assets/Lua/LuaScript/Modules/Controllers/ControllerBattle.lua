require 'Battle/BattleManager'
require 'Proto/Battle_pb'

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
            BattleManager:GetInstance().direction = direction
        end
        self.battleview.JoyStickEndDragCallback = function()
            Debugger.LogError('EndDragCallback')
        end

	end
	self.battleview:Show()
    BattleManager:GetInstance():Init()
    BattleManager:GetInstance():Start()

    local udppackage = Battle_pb.ReadyReq()
    local data = udppackage:SerializeToString()

	UdpNetwork:GetInstance():Send(1001,data)
end

return ControllerBattle