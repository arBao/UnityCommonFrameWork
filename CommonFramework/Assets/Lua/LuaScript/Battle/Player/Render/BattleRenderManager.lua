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

function BattleRenderManager:RefreshTarget(id)
    local renderObjs = BattleRenderObjectPool:GetInstance():GetPool()
    if renderObjs[id] ~= nil then
        local player = PlayerManager:GetInstance():GetPlayer(id)
        local renderHash = player.renderHash
        local itemID = 2
        player.positionRenderArray:ForEach(
        function(p)

            if itemID > renderHash:GetLength() then
                return true
            end

            local item = renderHash:Get(itemID)
            item.lastPosX = item.targetPosX
            item.lastPosY = item.targetPosY

            item.targetPosX = p.pos.x
            item.targetPosY = p.pos.y
            item.time = player.refreshPosPerTime

            item.speedX = (item.targetPosX - item.lastPosX)/ item.time
            item.speedY = (item.targetPosY - item.lastPosY) / item.time

            item.rotation = p.rotation

            item.timeCache = 0
            itemID = itemID + 1
        end)
    end
end

function BattleRenderManager:Update(deltaTime)

    local renderObjs = BattleRenderObjectPool:GetInstance():GetPool()
    for i = 1,#renderObjs do
        local playerID = renderObjs[i]
        local player = PlayerManager:GetInstance():GetPlayer(playerID)
        local renderHash = player.renderHash
        if self.playerShow[playerID] == nil then
            self.playerShow[playerID] = player
            local zDepth = 0
            renderHash:ForEach(function(renderID,renderHashItem)
                local obj = AssetsManager.Instance:GetAsset('Assets/Res/Model/Prefab/Head.prefab',typeof(UnityEngine.GameObject))
                renderHashItem.gameObject = obj
                local pos = Vector3.zero
                pos.x = renderHashItem.lastPosX
                pos.y = renderHashItem.lastPosY
                pos.z = zDepth
                obj.transform.position = pos
                obj.transform.rotation = renderHashItem.rotation
                zDepth = zDepth + 0.05
            end)
        else

        end

        local headHashItem = renderHash:Get(1)
        local pos = headHashItem.gameObject.transform.position
        pos.x = player.posX
        pos.y = player.posY
        headHashItem.gameObject.transform.position = pos
        headHashItem.gameObject.transform.rotation = player.rotation

        renderHash:ForEach(function(renderID,renderHashItem)
            if renderID ~= 1 then
                local pos = renderHashItem.gameObject.transform.position
                renderHashItem.timeCache = renderHashItem.timeCache + deltaTime

                if renderID == 2 then
                    --Debugger.LogError('renderHashItem.timeCache  ' .. renderHashItem.timeCache .. ' renderHashItem.time  ' .. renderHashItem.time
                    --.. ' renderHashItem.targetPosX ' .. renderHashItem.targetPosX .. '  deltaTime  ' .. deltaTime)
                end

                if renderHashItem.timeCache > renderHashItem.time then
                    --if renderID == 2 then
                    --    Debugger.LogError('renderHashItem.timeCache > renderHashItem.time  renderHashItem.timeCache  ' .. renderHashItem.timeCache
                    --    .. ' renderHashItem.targetPosX ' .. renderHashItem.targetPosX .. '  deltaTime  ' .. deltaTime)
                    --end
                    --renderHashItem.timeCache = renderHashItem.time
                end

                pos.x = renderHashItem.lastPosX + renderHashItem.speedX * renderHashItem.timeCache
                pos.y = renderHashItem.lastPosY + renderHashItem.speedY * renderHashItem.timeCache

                renderHashItem.gameObject.transform.position = pos
                renderHashItem.gameObject.transform.rotation = renderHashItem.rotation
            end
        end)
    end

end