---
--- Created by luzhuqiu.
--- DateTime: 2017/6/20 上午9:31
---

BattleRenderManager = class()

function BattleRenderManager:GetInstance()
    if self.m_instance == nil then
        self.m_instance = BattleRenderManager.new()
    end
    return self.m_instance
end

function BattleRenderManager:Update()
    local renderObjs = BattleRenderObjectPool:GetInstance():GetPool()

end