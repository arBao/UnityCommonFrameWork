---
--- Created by luzhuqiu.
--- DateTime: 2017/6/22 下午5:44
--- 用来中转各种同步数据,非同步数据不应该加进来

require 'Battle/BattleData/BattleData'

PlayerDataObType = {
    Direction = 1,
    IsSpeeding = 2,
    Score = 3,
}
----------------#############
--
--BattleDataObserverItem = class()
--function BattleDataObserverItem:ctor()
--    self.id = nil
--    self.observerType = nil
--    self.func = nil
--end

----------------#############


BattleDataManager = class()

function BattleDataManager:GetInstance()
    if self.m_instance == nil then
        self.m_instance = BattleDataManager.new()
    end
    return self.m_instance
end

function BattleDataManager:ctor()
    self.datas = {}
    self.observers = {}
end

function BattleDataManager:Clear()
    self.datas = {}
end

function BattleDataManager:AddPlayer(id)
    local data = BattleData.new()
    self.datas[id] = data
end

function BattleDataManager:GetPlayerData(id)
    return self.datas[id]
end

function BattleDataManager:DeletePlayer(id)
    self.datas[id] = nil
end

function BattleDataManager:SetDirection(id,directionX,directionY)
    if self.datas[id] ~= nil then
        self.datas[id].directionX = directionX
        self.datas[id].directionY = directionY

        if self.observers[id][PlayerDataObType.Direction] ~= nil then
            for k,v in pairs(self.observers[id][PlayerDataObType.Direction]) do
                v(id)
            end
        end
    end
end

function BattleDataManager:SetIsSpeeding(id,isSpeeding)
    if self.datas[id] ~= nil then
        self.datas[id].isSpeeding = isSpeeding

        if self.observers[id][PlayerDataObType.IsSpeeding] ~= nil then
            for k,v in pairs(self.observers[id][PlayerDataObType.IsSpeeding]) do
                v(id)
            end
        end
    end
end

function BattleDataManager:SetScore(id,score)
    if self.datas[id] ~= nil then
        self.datas[id].score = score

        if self.observers[id][PlayerDataObType.Score] ~= nil then
            for k,v in pairs(self.observers[id][PlayerDataObType.Score]) do
                v(id)
            end
        end
    end
end

function BattleDataManager:RemoveObserver(playerID,observerType,observerID)
    if self.observers[playerID] ~= nil then
        if self.observers[playerID][observerType] ~= nil then
            self.observers[playerID][observerType][observerID] = nil
        end
    end
end

function BattleDataManager:AddObserver(playerID,observerType,func)
    if self.observers[id] == nil then
        self.observers[id] = {}
    end
    if self.observers[id][observerType] == nil then
        self.observers[id][observerType] = {}
    end
    table.insert(self.observers[id][observerType],func)

    return #self.observers[id][observerType]
end