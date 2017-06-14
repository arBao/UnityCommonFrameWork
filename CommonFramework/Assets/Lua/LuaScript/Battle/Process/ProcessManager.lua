---
--- Created by luzhuqiu.
--- DateTime: 2017/6/9 上午11:56
---
require 'Battle/Process/Process'
require 'Battle/Process/ProcessConst'
require 'Battle/Process/ProcessModeFactory'
require 'Battle/BattleEventsManager'


ProcessManager = class()
function ProcessManager:GetInstance()
    if self.m_instance == nil then
        self.m_instance = ProcessManager.new()
    end
    return self.m_instance
end

function ProcessManager:Init(processModeName)
    self.processMode = ProcessModeFactory.Create(processModeName)
    self.processMode:Init()
    self.canUpdate = true
end

function ProcessManager:Update(deltaTime)
    if self.canUpdate then
        self.processMode:Update(deltaTime)
    end
    self.processMode:AlwaysUpdate(deltaTime)
end

function ProcessManager:Clear()
    self.processMode:Clear()
end
