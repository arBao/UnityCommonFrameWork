---
--- Created by luzhuqiu.
--- DateTime: 2017/6/22 下午5:44
---
require 'Battle/BattleData/BattleData'

BattleDataManager = class()

function BattleDataManager:GetInstance()
    if self.m_instance == nil then
        self.m_instance = BattleDataManager.new()
    end
    return self.m_instance
end

function BattleDataManager:ctor()
    self.datas = {}
end

function BattleDataManager:Clear()
    self.datas = {}
end

function BattleDataManager:AddPlayer(id)
    local data = BattleData.new()
    self.datas[id] = data
end

function BattleDataManager:DeletePlayer(id)
    self.datas[id] = nil
end

function BattleDataManager:SetDirection(id,directionX,directionY)
    if self.datas[id] ~= nil then
        self.datas[id].directionX = directionX
        self.datas[id].directionY = directionY
    end
end

function BattleDataManager:SetFastSpeeding(id,isFast)
    if self.datas[id] ~= nil then
        self.datas[id].isFastSpeeding = isFast
    end
end

function BattleDataManager:SetScore(id,score)
    if self.datas[id] ~= nil then
        self.datas[id].score = score
    end
end

function BattleDataManager:AddObserver(id)

end