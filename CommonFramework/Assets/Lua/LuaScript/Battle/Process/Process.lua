---
--- Created by luzhuqiu.
--- DateTime: 2017/6/14 下午1:58
---
Process = class()

function Process:ctor()
    self.processPriority = ProcessPriority.empty
    self.processState = ProcessState.ready
end

function Process:SetRequestCallback(callback)
    Debugger.LogError('SetRequestCallback ')
    self.requestCallback = callback
end

function Process:GetProcessPriority()
    return self:OnGetProcessPriority()
end

function Process:Request()
    Debugger.LogError('Process:Request()')
    if self.requestCallback ~= nil then
        self.requestCallback(self)
    end
end

function Process:Init()
    self:OnInit()
end

function Process:Begin()
    self:OnBegin()
end

function Process:Running(deltaTime)
    self:OnRunning(deltaTime)
end

function Process:End()
    self:OnEnd()
end

function Process:Pause()
    self:OnPause()
end

function Process:Resume()
    self:OnResume()
end

function Process:GetProcessState()
    return self.processState
end

function Process:SetProcessState(state)
    self.processState = state
end

function Process:ProcessWhenRequest()
    return false
end

-------------------重写的方法
function Process:OnInit()

end

function Process:OnGetProcessPriority()
    Debugger.LogError('Process:OnGetProcessPriority()')
    return self.processPriority
end

function Process:OnBegin()

end

function Process:OnRunning(deltaTime)

end

function Process:OnEnd()

end

function Process:OnPause()

end

function Process:OnResume()

end
