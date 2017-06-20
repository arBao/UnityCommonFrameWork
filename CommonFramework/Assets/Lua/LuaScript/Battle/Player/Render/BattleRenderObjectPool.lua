---
--- Created by luzhuqiu.
--- DateTime: 2017/6/19 下午7:02
---
BattleRenderObjectPool = class()

function BattleRenderObjectPool:GetInstance()
    if self.m_instance == nil then
        self.m_instance = BattleRenderObjectPool.new()
    end
    return self.m_instance
end

function BattleRenderObjectPool:ctor()
    self.renderPool = {}
end

function BattleRenderObjectPool:Clear()
    self.renderPool = {}
end

function BattleRenderObjectPool:Add(id)
    table.insert(self.renderPool,id)
end

function BattleRenderObjectPool:GetPool()
    return self.renderPool
end

