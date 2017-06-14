---
--- Created by luzhuqiu.
--- DateTime: 2017/6/14 下午2:37
---
BattleEventsManager = class()

function BattleEventsManager:GetInstance()
    if self.m_instance == nil then
        self.m_instance = BattleEventsManager.new()
    end
    return self.m_instance
end

function BattleEventsManager:ctor()
    self.idCache = {}
end

function BattleEventsManager:Register(message,func)
    local id = MessageCenter.AddListener(message,func)
    table.insert(self.idCache,id)
end

function BattleEventsManager:Clear()
    for i = 1,#self.idCache do
        MessageCenter.RemoveListener(self.idCache[i])
    end
    self.idCache = {}
end

function BattleEventsManager:Send(message,body)
    MessageCenter.SendMessage(message,body)
end