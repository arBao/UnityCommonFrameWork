---
--- Created by luzhuqiu.
--- DateTime: 2017/6/7 下午3:01
---
PlayerCreator = class()

function PlayerCreator:GetInstance()
    if self.m_instance == nil then
        self.m_instance = PlayerCreator.new()
    end
    return self.m_instance
end

function PlayerCreator:Create(pos)
    local obj = AssetsManager.Instance:GetAsset('Assets/Res/Model/Prefab/Player1.prefab',typeof(UnityEngine.GameObject))
    obj.transform.position = pos
    return obj
end