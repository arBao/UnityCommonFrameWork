---
--- Created by luzhuqiu.
--- DateTime: 2017/6/19 下午2:46
---

require 'Battle/Player/Logic/PlayerLogicHash'
require 'Battle/Player/Logic/PlayerLogicHashItem'
require 'Battle/Player/Render/PlayerRenderHash'
require 'Battle/Player/Render/PlayerRenderHashItem'
require 'Battle/Player/PositionArray'
require 'Battle/Player/BattleData/BattleDataManager'

Player = class(BattleLogicObject)

---分数驱动，分数改变,速度改变的时候都要重算
function Player:CalPlayerValue()
    --self.length = score * self.lengthFactor
    --self.radius = score * self.radiusFactor
    --self.amout = self.length / (self.radius * self.spaceRadiusScale)
    --self.rotateMax = self.runSpeed * self.runSpeedFactor * self.refreshPosPerTime * 180 / (math.pi * score * self.radiusFactor)

    self.length = self.lengthA1 * math.pow(self.score,self.lengthB1)
    self.radius = self.radiusA2 * math.pow(self.score,self.radiusB2)
    self.rotateMax = self.radius * self.rotateMaxA3 * self.runBaseSpeed * self.runSpeedFactor
    self.amount = math.floor(self.length / self.radius / self.spaceRadiusScale)
    self.refreshPosPerTime = self.radius * self.spaceRadiusScale / self.runBaseSpeed / self.runSpeedFactor

    Debugger.LogError('self.length  ' .. self.length .. '  self.radius  ' .. self.radius .. '  self.rotateMax  '
    .. self.rotateMax .. '  self.amount  ' .. self.amount .. ' self.refreshPosPerTime  ' .. self.refreshPosPerTime)
end

function Player:ctor()

    ---分数
    self.score = score
    ---最小分值
    self.scoreMin = 100

    ---长度
    self.length = 0
    ---长度乘法因子,读表
    self.lengthA1 = 0.598
    ---长度求幂因子,读表
    self.lengthB1 = 0.8

    ---半径
    self.radius = 0
    ---半径乘法因子,读表
    self.radiusA2 = 0.11
    ---半径求幂因子,读表
    self.radiusB2 = 0.485

    ---最大转弯角度
    self.rotateMax = 0
    ---最大转弯角度乘法因子,读表
    self.rotateMaxA3 = 1.5

    ---节间距等于多少半径,读表
    self.spaceRadiusScale = 0.4
    ---行进基础速度
    self.runBaseSpeed = 5
    ---行进速度倍率,会受加速影响而变化
    self.runSpeedFactor = 1
    ---是否加速
    self.isSpeeding = false

    ---多长时间刷新一次位置，单位为秒
    self.refreshPosPerTime = 0
    ---刷新位置时间缓存
    self.refreshPosTimeCache = 0
    ---节数:由长度以及半径还有节间距决定
    self.amount = 0

    ---当前X方向，由玩家数据和当前值共同得出
    self.directionX = 0
    ---当前Y方向，由玩家数据和当前值共同得出
    self.directionY = 0

end

function Player:Init(id,score,startPos)
    self.id = id
    self.logicHash = PlayerLogicHash.new()
    self.renderHash = PlayerRenderHash.new()

    local funcDirectionChange = function()
        local playerData = BattleDataManager:GetInstance():GetPlayerData(id)

    end
    self.funcDirectionChangeID = BattleDataManager:GetInstance():AddObserver(id,PlayerDataObType.Direction,funcDirectionChange)

    local funcIsSpeedingChange = function()
        local playerData = BattleDataManager:GetInstance():GetPlayerData(id)
        self.isSpeeding = playerData.isSpeeding
        if self.isSpeeding then
            self.runSpeedFactor = 2
        else
            self.runSpeedFactor = 1
        end
        self:CalPlayerValue()
    end
    self.funcIsSpeedingChangeID =  BattleDataManager:GetInstance():AddObserver(id,PlayerDataObType.IsSpeeding,funcIsSpeedingChange)

    local funcScoreChange = function()
        local playerData = BattleDataManager:GetInstance():GetPlayerData(id)
        self.score = playerData.score
        self:CalPlayerValue()
    end
    self.funcScoreChangeID = BattleDataManager:GetInstance():AddObserver(id,PlayerDataObType.Score,funcScoreChange)

    self:CalPlayerValue(score)

    if startPos.x >= 0 then
        self.rotationZ = -270
        self.directionX = -1
        self.directionY = 0
    else
        self.rotationZ = -90
        self.directionX = 1
        self.directionY = 0
    end

    self.posX = startPos.x
    self.posY = startPos.y

    for i = 1,self.amount,1 do

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

    end

    self.logicHash:RefreshLength()
    self.renderHash:RefreshLength()

    self.positionLogicArray = PositionArray.new()
    self.positionLogicArray:SetSize(self.amount)

    for i = 1,self.amount,1 do
        self.positionLogicArray:Push(self.posX,self.posY,self.rotationZ,self.refreshPosPerTime)
    end

    self.positionRenderArray = PositionArray.new()
    self.positionRenderArray:SetSize(self.amount)

    for i = 1,self.amount,1 do
        self.positionRenderArray:Push(self.posX,self.posY,self.rotationZ,self.refreshPosPerTime)
    end
end

function Player:SetSize(size)
    self.positionLogicArray:SetSize(size)
    self.positionRenderArray:SetSize(size)
end

function Player:Update(time)
    local rotationZ = Mathf.Rad2Deg * Mathf.Asin(self.directionY)

    ---象限变换
    if self.directionX > 0 then
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

    self.refreshPosTimeCache = self.refreshPosTimeCache + time

    if self.refreshPosTimeCache > (self.refreshPosPerTime) then
        local delta = self.refreshPosTimeCache - self.refreshPosPerTime
        self.posX = self.posX + (time - delta) * self.runBaseSpeed * self.runSpeedFactor * xDirection
        self.posY = self.posY + (time - delta) * self.runBaseSpeed * self.runSpeedFactor * yDirection
    else
        self.posX = self.posX + time * self.runBaseSpeed * self.runSpeedFactor * xDirection
        self.posY = self.posY + time * self.runBaseSpeed * self.runSpeedFactor * yDirection
    end

    if self.refreshPosTimeCache > (self.refreshPosPerTime) then
        self.refreshPosTimeCache = 0--self.refreshPosTimeCache - self.refreshPosPerTime
        self.positionLogicArray:Push(self.posX,self.posY,self.rotationZ,self.refreshPosPerTime)
        self.positionRenderArray:Push(self.posX,self.posY,self.rotationZ,self.refreshPosPerTime)
        BattleRenderManager:GetInstance():RefreshTarget(self.id)
    end

end

function Player:OnDestroy()
    BattleDataManager:GetInstance():RemoveObserver(self.id,PlayerDataObType.Direction,self.funcDirectionChangeID)
    BattleDataManager:GetInstance():RemoveObserver(self.id,PlayerDataObType.IsSpeeding,self.funcIsSpeedingChangeID)
    BattleDataManager:GetInstance():RemoveObserver(self.id,PlayerDataObType.Score,self.funcScoreChangeID)
end