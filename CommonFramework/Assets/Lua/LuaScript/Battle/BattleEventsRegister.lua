---
--- Created by luzhuqiu.
--- DateTime: 2017/6/14 下午2:37
---
BattleEventsRegister = class()

function BattleEventsRegister:GetInstance()
    if self.m_instance == nil then
        self.m_instance = BattleEventsRegister.new()
    end
end

function BattleEventsRegister:ctor()
    self.idCache = {}
end

function BattleEventsRegister:Register(message,func)

end

function BattleEventsRegister:Clear()
    for i = 1,#self.idCache do

    end
    self.idCache = {}
end