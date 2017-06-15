---
--- Created by luzhuqiu.
--- DateTime: 2017/6/15 上午9:30
---
ProcessPlot = class(Process)
function ProcessPlot:OnInit()
    Debugger.LogError('ProcessPlot:OnInit()')
    local funcPlayPlot = function()
        Debugger.LogError('ProcessPlot Request')
        self:Request()
    end

    local funcEndPlot = function()
        self:SetProcessState(ProcessState.finish)
    end
    BattleEventsManager:GetInstance():Register('PlayPlot',funcPlayPlot)
    BattleEventsManager:GetInstance():Register('EndPlot',funcEndPlot)
end

function ProcessPlot:OnGetProcessPriority()
    Debugger.LogError('ProcessPlot:OnGetProcessPriority()')
    return ProcessPriority.playPlot
end

function ProcessPlot:OnBegin()
    Debugger.LogError('ProcessPlot OnBegin  ')
    self:SetProcessState(ProcessState.running)
end

function ProcessPlot:OnRunning(deltaTime)
    Debugger.LogError('ProcessPlot:OnRunning  ' .. deltaTime)
end

function ProcessPlot:OnEnd()
    Debugger.LogError('ProcessPlot OnEnd  ')
end

function ProcessPlot:OnPause()
    Debugger.LogError('ProcessPlot OnEnd  ')
end

function ProcessPlot:OnResume()
    Debugger.LogError('ProcessPlot OnResume  ')
end
