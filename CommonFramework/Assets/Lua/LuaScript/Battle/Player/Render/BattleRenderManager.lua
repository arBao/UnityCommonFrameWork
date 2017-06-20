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
    self.playerShow = {}
end

function BattleRenderManager:Update()
    local renderObjs = BattleRenderObjectPool:GetInstance():GetPool()
    for i = 1,#renderObjs do
        local playerID = renderObjs[i]
        local player = PlayerManager:GetInstance():GetPlayer(playerID)
        local renderHash = player.renderHash
        if self.playerShow[playerID] == nil then
            self.playerShow[playerID] = player
            local zDepth = 0
            renderHash:ForEach(function(renderHashItem)
                local obj = AssetsManager.Instance:GetAsset('Assets/Res/Model/Prefab/Head.prefab',typeof(UnityEngine.GameObject))
                renderHashItem.gameObject = obj
                local pos = Vector3.zero
                pos.z = zDepth
                obj.transform.position = pos
                zDepth = zDepth + 0.05
            end)
        else

        end

        local itemID = 1
        player.positionRenderArray:ForEach(
        function(p)
            local item = renderHash:Get(itemID)
            local pos = item.gameObject.transform.position
            pos.x = p.pos.x
            pos.y = p.pos.y
            item.gameObject.transform.position = pos
            item.gameObject.transform.rotation = p.rotation
        end)
    end


end