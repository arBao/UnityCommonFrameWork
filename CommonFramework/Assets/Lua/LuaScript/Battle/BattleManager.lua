---
--- Created by luzhuqiu.
--- DateTime: 2017/6/7 下午2:45
---
require 'Battle/Process/ProcessManager'
BattleManager = class()
function BattleManager:GetInstance()
    if self.m_instance == nil then
        self.m_instance = BattleManager.new()
    end
    return self.m_instance
end

function BattleManager:Init()
    self.direction = Vector2.New(1,0)
    ProcessManager:GetInstance():Init('ProcessModeNormal')
end

function BattleManager:Start()
    BattleEventsManager:GetInstance():Send('BattleReady',nil)
    UpdateBeat:Add(self.Update, self)
end

function BattleManager.Update(self)
    local timeDelta = Time.deltaTime
    ProcessManager:GetInstance():Update(timeDelta)
end

function BattleManager:Clear()

end