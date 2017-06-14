---
--- Created by luzhuqiu.
--- DateTime: 2017/6/14 下午1:58
---
Process = class()

function Process:ctor()
    self.processPriority = ProcessPriority.empty
    self.processState = ProcessState.ready
end

function Process:GetProcessPriority()
    return self.processPriority
end

function Process:Request()

end

function Process:Begin()

end

function Process:Running()

end

function Process:End()

end

function Process:Pause()

end

function Process:Resume()

end

function Process:GetProcessState()
    return self.processState
end

function Process:SetProcessState(state)
    self.processState = state
end


