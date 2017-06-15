---
--- Created by luzhuqiu.
--- DateTime: 2017/6/14 下午2:50
--- 凡是带On字眼的才是子类继承。
ProcessMode = class()

function ProcessMode:ctor()

end

function ProcessMode:Init()
    ---写一些公共的Init方法
    self:OnInit()
    self.processInQueue = {}
    for i=1,#self.listProcess do
        local process = self.listProcess[i]
        local callback = function(processParm)
            Debugger.LogError('SetRequestCallback  callback 1')

            self:InsertIProcess(processParm)
            if processParm:ProcessWhenRequest() then
                self:Process(Time.deltaTime)
            end
        end
        process:SetRequestCallback(callback)
    end

    self.currentProcess = nil
end

function ProcessMode:AddProcess(process)
    if self.listProcess == nil then
        self.listProcess = {}
    end
    table.insert(self.listProcess,process)
    process:Init()
end

function ProcessMode:GetProcesses()
    return self.listProcess
end

function ProcessMode:Clear()
    BattleEventsRegister:GetInstance():Clear()
    self.listProcess = {}
    self.currentProcess = nil

    self:OnClear()
end

function ProcessMode:AlwaysUpdate(deltaTime)
    self:OnAlwaysUpdate(deltaTime)
end

function ProcessMode:Update(deltaTime)
    self:Process(deltaTime)
    self:OnUpdate(deltaTime)
end

function ProcessMode:InsertIProcess(process)
    if arrayContain(self.processInQueue,process) then
        return
    end
    Debugger.LogError('InsertIProcess 1111  ' .. #self.processInQueue)
    if #self.processInQueue == 0 then
        table.insert(self.processInQueue,process)
    else
        local haveInsert = false
        for i = 1,#self.processInQueue do
            local priorityOrigin = self.processInQueue[i]:GetProcessPriority()
            local priorityNew = process:GetProcessPriority()
            if priorityOrigin < priorityNew then
                haveInsert = true
                table.insert(self.processInQueue,i,process)
                break
            end

        end
        if haveInsert == false then
            table.insert(self.processInQueue,process)
        end
    end

    Debugger.LogError('InsertIProcess 222222  ' .. #self.processInQueue)
end

function ProcessMode:Process(deltaTime)
    if #self.processInQueue ~= 0 then
        if self.currentProcess == nil then
            self.currentProcess = self.processInQueue[1]
        end
        if self.currentProcess == self.processInQueue[1] then
            if self.currentProcess:GetProcessState() == ProcessState.ready then
                self.currentProcess:Begin()
            elseif self.currentProcess:GetProcessState() == ProcessState.pause then
                self.currentProcess:Resume()
            elseif self.currentProcess:GetProcessState() == ProcessState.running then
                self.currentProcess:Running(deltaTime)
            elseif self.currentProcess:GetProcessState() == ProcessState.finish then
                self.currentProcess:End()
                self.currentProcess:SetProcessState(ProcessState.ready)
                table.remove(self.processInQueue,1)
                self.currentProcess = nil
                self:Process(deltaTime)
            end
        else
            self.currentProcess:Pause()
            self.currentProcess = self.processInQueue[1]
            self:Process(deltaTime)
        end
    end
end

----------------重写方法
function ProcessMode:OnInit()

end

function ProcessMode:OnClear()

end

function ProcessMode:OnAlwaysUpdate(deltaTime)

end

function ProcessMode:OnUpdate(deltaTime)

end

