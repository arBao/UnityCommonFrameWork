---
--- Created by luzhuqiu.
--- DateTime: 2017/6/19 下午2:46
---

require 'Battle/Player/Logic/PlayerLogicHash'
require 'Battle/Player/Logic/PlayerLogicHashItem'
require 'Battle/Player/Render/PlayerRenderHash'
require 'Battle/Player/Render/PlayerRenderHashItem'
require 'Battle/Player/PositionArray'

Player = class(BattleLogicObject)

function Player:Init(id,long,startPos)
    self.id = id
    self.logicHash = PlayerLogicHash.new()
    self.renderHash = PlayerRenderHash.new()

    ---每一节的间隔距离
    self.partSpace = 0.3
    ---行进速度
    self.runSpeed = 2
    ---旋转速度
    self.rotateSpeed = 0.1
    ---多长时间改变一次位置
    self.refreshPosPerTime = 0.2
    ---刷新位置时间缓存
    self.refreshPosTimeCache = 0

    if startPos.x >= 0 then
        self.rotationZ = -90
    else
        self.rotationZ = 90
    end

    self.posX = startPos.x
    self.posY = startPos.y

    for i = 1,long,1 do

        local logicItem = PlayerLogicHashItem.new()
        local renderItem = PlayerRenderHashItem.new()

        logicItem.lastPosX = self.posX
        logicItem.lastPosY = self.posY
        logicItem.rotationZ = self.rotationZ
        logicItem.time = self.refreshPosPerTime

        renderItem.lastPosX = self.posX
        renderItem.lastPosY = self.posY
        renderItem.targetPosX = self.posX
        renderItem.targetPosY = self.posY
        renderItem.rotationZ = self.rotationZ
        renderItem.time = self.refreshPosPerTime

        self.logicHash:Add(i,logicItem)
        self.renderHash:Add(i,renderItem)

        renderItem.totalFrame = self.refreshPosPerTime

    end

    self.logicHash:RefreshLength()
    self.renderHash:RefreshLength()

    self.positionLogicArray = PositionArray.new()
    self.positionLogicArray:SetSize(long)

    for i = 1,long,1 do
        self.positionLogicArray:Push(self.posX,self.posY,self.rotationZ)
    end

    self.positionRenderArray = PositionArray.new()
    self.positionRenderArray:SetSize(long)

    for i = 1,long,1 do
        self.positionRenderArray:Push(self.posX,self.posY,self.rotationZ)
    end
end

function Player:SetSize(size)
    self.positionLogicArray:SetSize(size)
    self.positionRenderArray:SetSize(size)
end

function Player:Move(time)
    local direction = BattleManager:GetInstance().direction

    local rotationZ = Mathf.Rad2Deg * Mathf.Asin(direction.y)

    local anchorAdd = 0
    if direction.x > 0 then
        rotationZ = rotationZ - 90
    else
        rotationZ = -270 - rotationZ
    end

    --Debugger.LogError('direction.x  ' .. direction.x .. '  direction.y  ' .. direction.y .. ' rotationZ ' .. Mathf.Rad2Deg * Mathf.Asin(direction.y))
    self.posX = self.posX + time * self.runSpeed * direction.x
    self.posY = self.posY + time * self.runSpeed * direction.y
    self.refreshPosTimeCache = self.refreshPosTimeCache + time
    self.rotationZ = rotationZ

    --- 减去time是为了平滑处理视觉效果 减去停掉的一帧
    if self.refreshPosTimeCache > self.refreshPosPerTime - time then
        self.refreshPosTimeCache = 0
        self.positionLogicArray:Push(self.posX,self.posY,self.rotationZ)
        self.positionRenderArray:Push(self.posX,self.posY,self.rotationZ)
        BattleRenderManager:GetInstance():RefreshTarget(self.id)
    end

end