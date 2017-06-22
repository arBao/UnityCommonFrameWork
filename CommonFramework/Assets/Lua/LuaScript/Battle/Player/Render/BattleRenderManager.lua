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
    self.rotationCache = Quaternion.Euler(0,0,0)
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
            item.lastRotationZ = item.targetRotationZ

            item.targetPosX = p.posX
            item.targetPosY = p.posY
            item.targetRotationZ = p.rotationZ

            item.time = p.time

            item.speedX = (item.targetPosX - item.lastPosX)/ item.time
            item.speedY = (item.targetPosY - item.lastPosY) / item.time

            ---如果是由第四象限转到第一象限以及由第一象限转到第四象限，要分情况讨论避免产生突变
            if item.lastRotationZ > -360 and item.lastRotationZ < -270 and item.targetRotationZ > -90 then
                item.lastRotationZ = 360 + item.lastRotationZ

            elseif item.lastRotationZ > -90 and item.targetRotationZ > -360 and item.targetRotationZ < -270 then
                item.lastRotationZ = -360 + item.lastRotationZ
            end
            item.speedRotationZ = (item.targetRotationZ - item.lastRotationZ)/ item.time

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
                obj.transform.rotation = self.rotationCache:SetEuler(0,0,renderHashItem.lastRotationZ)--Quaternion.Euler(0,0,renderHashItem.lastRotationZ)
                obj.transform.localScale = Vector3.New(player.radius,player.radius,0)
                zDepth = zDepth + 0.05
            end)
        else

        end

        local headHashItem = renderHash:Get(1)
        local pos = headHashItem.gameObject.transform.position
        pos.x = player.posX
        pos.y = player.posY
        headHashItem.gameObject.transform.position = pos
        headHashItem.gameObject.transform.rotation = self.rotationCache:SetEuler(0,0,player.rotationZ)--Quaternion.Euler(0,0,player.rotationZ)--player.rotation

        if playerID == 1 then
            CameraManager:GetInstance():SetCameraPos(player.posX,player.posY)
        end

        renderHash:ForEach(function(renderID,renderHashItem)
            if renderID ~= 1 then
                local pos = renderHashItem.gameObject.transform.position
                renderHashItem.timeCache = renderHashItem.timeCache + deltaTime

                if renderHashItem.timeCache > renderHashItem.time then
                    renderHashItem.timeCache = renderHashItem.time
                end

                pos.x = renderHashItem.lastPosX + renderHashItem.speedX * renderHashItem.timeCache
                pos.y = renderHashItem.lastPosY + renderHashItem.speedY * renderHashItem.timeCache

                local rotationZ = renderHashItem.lastRotationZ + renderHashItem.speedRotationZ * renderHashItem.timeCache

                renderHashItem.gameObject.transform.position = pos
                renderHashItem.gameObject.transform.rotation = self.rotationCache:SetEuler(0,0,rotationZ)
            end
        end)
    end

end