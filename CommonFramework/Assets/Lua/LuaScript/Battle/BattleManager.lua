---
--- Created by luzhuqiu.
--- DateTime: 2017/6/7 下午2:45
---
require 'Battle/PlayerCreator'
require 'Battle/FrameSyncSystem/FrameManager'
BattleManager = class()
function BattleManager:GetInstance()
    if self.m_instance == nil then
        self.m_instance = BattleManager.new()
    end
    return self.m_instance
end

function BattleManager:Init()
    --创建角色
    self.direction = Vector2.New(1,0)
    local obj = PlayerCreator:GetInstance():Create(Vector3.New(0,0,0))
    local function GameLogicUpdateFunc(deltaTime)
        local pos = obj.transform.position
        pos.x = pos.x + deltaTime * 1 * self.direction.x
        pos.y = pos.y + deltaTime * 1 * self.direction.y
        obj.transform.position = pos
    end
    FrameManager:GetInstance():Init(GameLogicUpdateFunc)
end

function BattleManager:Ready()

end

function BattleManager:Start()
    --预留processmanager
    self.time = 0
    UpdateBeat:Add(BattleManager.Update, self)
end

function BattleManager.Update(self)
    FrameManager:GetInstance():Update(Time.deltaTime)
end