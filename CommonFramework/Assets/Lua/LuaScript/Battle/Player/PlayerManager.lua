---
--- Created by luzhuqiu.
--- DateTime: 2017/6/7 下午3:01
---
require 'Battle/Player/Player'

PlayerManager = class()

function PlayerManager:GetInstance()
    if self.m_instance == nil then
        self.m_instance = PlayerManager.new()
    end
    return self.m_instance
end

function PlayerManager:ctor()
    self.players = {}
end

function PlayerManager:GetPlayer(id)
    return self.players[id]
end

function PlayerManager:GetPlayers()
    return self.players
end

function PlayerManager:Create(id,score,pos)

    local player = Player.new()
    player:Init(id,score,pos)
    self.players[id] = player

    return player

    --local obj = AssetsManager.Instance:GetAsset('Assets/Res/Model/Prefab/Player1.prefab',typeof(UnityEngine.GameObject))
    --obj.transform.position = pos
    --return obj
end