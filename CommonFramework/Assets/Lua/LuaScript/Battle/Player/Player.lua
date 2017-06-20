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
    self.runSpeed = 0.1
    ---旋转速度
    self.rotateSpeed = 0.1
    ---多少帧改变一次位置
    self.refreshFramePos = 5
    ---刷新位置帧数缓存
    self.refreshFramePosCache = 0

    local startRotation = nil

    if startPos.x >= 0 then
        startRotation = Quaternion.Euler(0,0,90)
    else
        startRotation = Quaternion.Euler(0,0,-90)
    end

    for i = 1,long,1 do

        local logicItem = PlayerLogicHashItem.new()
        local renderItem = PlayerRenderHashItem.new()

        self.logicHash:Add(i,logicItem)
        self.renderHash:Add(i,renderItem)

    end

    self.positionLogicArray = PositionArray.new()
    self.positionLogicArray:SetSize(long)

    for i = 1,long,1 do
        self.positionLogicArray:Push(startPos,startRotation)
    end

    self.positionRenderArray = PositionArray.new()
    self.positionRenderArray:SetSize(long)

    for i = 1,long,1 do
        self.positionRenderArray:Push(startPos,startRotation)
    end
end

function Player:SetSize(size)
    self.positionLogicArray:SetSize(size)
    self.positionRenderArray:SetSize(size)
end

function Player:Move(time)

    self.refreshFramePosCache = self.refreshFramePosCache + 1
    if self.refreshFramePosCache > self.refreshFramePos then
        self.refreshFramePosCache = 0
        self.positionLogicArray:Push(headLogicItem.pos.x,headLogicItem.pos.y,headLogicItem.rotation)
        self.positionRenderArray:Push(headLogicItem.pos.x,headLogicItem.pos.y,headLogicItem.rotation)
    end

end