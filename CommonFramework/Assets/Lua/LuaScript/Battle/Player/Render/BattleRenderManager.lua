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

function BattleRenderManager:ctor()
    self.showObjs = {}
end

function BattleRenderManager:Update()
    local renderObjs = BattleRenderObjectPool:GetInstance():GetPool()
    for i = 1,#renderObjs do
        local renderLink = PlayerManager:GetInstance():GetPlayer(renderObjs[i]).renderLink
        if self.showObjs[renderObjs[i]] == nil then
            self.showObjs[renderObjs[i]] = renderObjs[i]
            local zDepth = 0
            renderLink:ForEach(function(renderLinkItem)
                local obj = AssetsManager.Instance:GetAsset('Assets/Res/Model/Prefab/Head.prefab',typeof(UnityEngine.GameObject))
                local pos = Vector3.zero
                pos.x = renderLinkItem.pos.x
                pos.y = renderLinkItem.pos.y
                pos.z = zDepth
                obj.transform.position = pos
                obj.transform.rotation = renderLinkItem.rotation
                zDepth = zDepth + 0.05
            end)
        end
    end
end