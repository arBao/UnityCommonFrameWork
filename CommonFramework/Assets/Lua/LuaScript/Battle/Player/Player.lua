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
    ---最大转弯角度
    self.rotateMax = 2
    ---多长时间改变一次位置
    self.refreshPosPerTime = 0.2
    ---刷新位置时间缓存
    self.refreshPosTimeCache = 0

    if startPos.x >= 0 then
        self.rotationZ = -270
        BattleManager:GetInstance().direction = Vector2.New(-1,0)
    else
        self.rotationZ = -90
        BattleManager:GetInstance().direction = Vector2.New(1,0)
    end

    self.posX = startPos.x
    self.posY = startPos.y

    for i = 1,long,1 do

        local logicItem = PlayerLogicHashItem.new()
        local renderItem = PlayerRenderHashItem.new()

        logicItem.lastPosX = self.posX
        logicItem.lastPosY = self.posY
        logicItem.rotationZ = self.rotationZ
        logicItem.lastRotationZ = self.rotationZ
        logicItem.time = self.refreshPosPerTime

        renderItem.lastPosX = self.posX
        renderItem.lastPosY = self.posY
        renderItem.targetPosX = self.posX
        renderItem.targetPosY = self.posY
        renderItem.lastRotationZ = self.rotationZ
        renderItem.targetRotationZ = self.rotationZ
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

    ---象限变换
    if direction.x > 0 then
        rotationZ = rotationZ - 90
    else
        rotationZ = -270 - rotationZ
    end

    ---第四象限变换到第一象限突变处理
    if self.rotationZ > -360 and self.rotationZ < -270 and rotationZ > -90 then
        self.rotationZ = 360 + self.rotationZ

    elseif self.rotationZ > -90 and self.rotationZ > -360 and rotationZ < -270 then
        self.rotationZ = -360 + self.rotationZ
    end

    ---转弯幅度限制在最大转弯内
    local deltaRotationZ = rotationZ - self.rotationZ

    if math.abs(deltaRotationZ) > self.rotateMax then
        if deltaRotationZ > 0 then
            self.rotationZ = self.rotationZ + self.rotateMax
        else
            self.rotationZ = self.rotationZ - self.rotateMax
        end
    end

    if self.rotationZ > 0 then
        self.rotationZ = -360 + self.rotationZ
    elseif self.rotationZ < -360 then
        self.rotationZ = self.rotationZ + 360
    end

    --Debugger.LogError('self.rotationZ  ' .. self.rotationZ)

    local xDirection = math.abs(math.sin(self.rotationZ * Mathf.Deg2Rad))
    local yDirection = math.abs(math.cos(self.rotationZ * Mathf.Deg2Rad))

    --Debugger.LogError('xDirection  ' .. xDirection)
    --Debugger.LogError('yDirection  ' .. yDirection)

    if (self.rotationZ >= -90 and self.rotationZ < 0) or self.rotationZ < -360 then
        --Debugger.LogError('第一象限')
    elseif self.rotationZ < -90 and self.rotationZ >= -180 then
        --Debugger.LogError('第二象限')
        yDirection = 0 - yDirection
    elseif self.rotationZ < -180 and self.rotationZ >= -270 then
        --Debugger.LogError('第三象限')
        xDirection = 0 - xDirection
        yDirection = 0 - yDirection
    else
        --Debugger.LogError('第四象限')
        xDirection = 0 - xDirection
    end

    --Debugger.LogError('direction.x  ' .. direction.x .. '  direction.y  ' .. direction.y .. ' rotationZ ' .. Mathf.Rad2Deg * Mathf.Asin(direction.y))
    self.posX = self.posX + time * self.runSpeed * xDirection
    self.posY = self.posY + time * self.runSpeed * yDirection
    self.refreshPosTimeCache = self.refreshPosTimeCache + time

    --- 减去time是为了平滑处理视觉效果 减去停掉的一帧
    if self.refreshPosTimeCache > self.refreshPosPerTime - time then
        self.refreshPosTimeCache = 0
        self.positionLogicArray:Push(self.posX,self.posY,self.rotationZ)
        self.positionRenderArray:Push(self.posX,self.posY,self.rotationZ)
        BattleRenderManager:GetInstance():RefreshTarget(self.id)
    end

end