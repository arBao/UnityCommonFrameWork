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
        self.playingPlot = false
        self.battleview = self:GetView('ViewUIBattle')
        self.battleview.onClickButtonSpeedCallback = function ()
            Debugger.LogError('onClickButtonSpeedCallback')

        end

        self.battleview.onClickBtnAddScoreCallback = function ()
            Debugger.LogError('onClickBtnAddScoreCallback')
        end

        self.battleview.onClickBtnMinusScoreCallback = function ()
            Debugger.LogError('onClickBtnMinusScoreCallback')
        end

        self.battleview.onClickBtnTestProcessModeCallback = function ()
            Debugger.LogError('onClickBtnTestProcessModeCallback')
            self.playingPlot = not(self.playingPlot)
            if self.playingPlot then
                BattleEventsManager:GetInstance():Send('PlayPlot')
            else
                BattleEventsManager:GetInstance():Send('EndPlot')
            end
        end

        self.battleview.JoyStickOnDragCallback = function(direction)
            --Debugger.LogError("direction.x   " .. direction.x .. '  direction.y  ' .. direction.y)
            --BattleManager:GetInstance().direction = direction
            BattleDataManager:GetInstance():SetDirection(1,direction.x,direction.y)
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

    --UdpNetwork:GetInstance():Send(1001,data)
end

return ControllerBattle