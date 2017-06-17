---
--- Created by luzhuqiu.
--- DateTime: 2017/6/14 下午4:09
---
ProcessFight = class(Process)

function ProcessFight:OnInit()
    Debugger.LogError('ProcessFight:OnInit()')
    local funcBattleReady = function()
        self:Request()
    end
    BattleEventsManager:GetInstance():Register('BattleReady',funcBattleReady)
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



