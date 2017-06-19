---
--- Created by luzhuqiu.
--- DateTime: 2017/6/14 下午4:09
---

require 'Battle/Player/PlayerManager'
require 'Battle/FrameSyncSystem/FrameManager'
require 'Battle/Collider/ColliderManager'

ProcessFight = class(Process)

function ProcessFight:OnInit()
    Debugger.LogError('ProcessFight:OnInit()')
    local funcBattleReady = function()
        self:Request()
    end
    BattleEventsManager:GetInstance():Register('BattleReady',funcBattleReady)

    --创建角色
    self.player1 = PlayerManager:GetInstance():Create(1,5,Vector3.New(0,0,0))
    local GameLogicUpdateFunc = function(deltaTime)
        ColliderManager:GetInstance():Clean()
        --ColliderManager:GetInstance():Stack(Vector2.New(pos1.x,pos1.y),1,1,111,1)
        --ColliderManager:GetInstance():Stack(Vector2.New(pos2.x,pos2.y),1,1,222,2)
        --ColliderManager:GetInstance():Stack(Vector2.New(pos3.x,pos3.y),1,1,333,3)

        local pairs = ColliderManager:GetInstance():ColliderDetect()
        if #pairs ~= 0 then
            Debugger.LogError('--------------------' )
        end

        for i=1,#pairs do
            local pair = pairs[i]
            Debugger.LogError('##########' )
            Debugger.LogError('pair.element1.id  ' .. pair.element1.id .. '  pair.element1.type  ' .. pair.element1.type )
            Debugger.LogError('pair.element2.id  ' .. pair.element2.id .. '  pair.element2.type  ' .. pair.element2.type )
        end

        CameraManager:GetInstance():GetBattleCameraField()

        --local inCameraArea = CameraManager:GetInstance():CameraAreaTest(Vector2.New(pos1.x,pos1.y))
        --if inCameraArea then
        --    Debugger.LogError('-------------------- inCameraArea ')
        --end
    end
    FrameManager:GetInstance():Init(GameLogicUpdateFunc)
    ColliderManager:GetInstance():Init()
end

function ProcessFight:OnGetProcessPriority()
    Debugger.LogError('ProcessFight:OnGetProcessPriority()')
    return ProcessPriority.fight
end

function ProcessFight:OnBegin()
    Debugger.LogError('ProcessFight OnBegin  ')
    self:SetProcessState(ProcessState.running)
end

function ProcessFight:OnRunning(deltaTime)
    --Debugger.LogError('ProcessFight:OnRunning  ' .. deltaTime)
    FrameManager:GetInstance():Update(deltaTime)
end

function ProcessFight:OnEnd()
    Debugger.LogError('ProcessFight OnEnd  ')
end

function ProcessFight:OnPause()
    Debugger.LogError('ProcessFight OnEnd  ')
end

function ProcessFight:OnResume()
    Debugger.LogError('ProcessFight OnResume  ')
end



