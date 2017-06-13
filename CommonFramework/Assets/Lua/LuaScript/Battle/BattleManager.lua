---
--- Created by luzhuqiu.
--- DateTime: 2017/6/7 下午2:45
---
require 'Battle/Player/PlayerCreator'
require 'Battle/FrameSyncSystem/FrameManager'
require 'Battle/Collider/ColliderManager'
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
    self.obj1 = PlayerCreator:GetInstance():Create(Vector3.New(0,0,0))
    self.obj2 = PlayerCreator:GetInstance():Create(Vector3.New(1,0,0))
    local GameLogicUpdateFunc = function(deltaTime)
        --local pos = obj.transform.position
        --pos.x = pos.x + deltaTime * 1 * self.direction.x
        --pos.y = pos.y + deltaTime * 1 * self.direction.y
        --obj.transform.position = pos
    end
    FrameManager:GetInstance():Init(GameLogicUpdateFunc)
    ColliderManager:GetInstance():Init()
    --ColliderManager:GetInstance():Stack(Vector2.New(0.6,0.6),1,1,1)

    --ColliderManager:GetInstance():Stack(Vector2.New(0.3,0.3),1,1,1)
end



function BattleManager:Ready()

end

function BattleManager:Start()
    --预留processmanager
    self.time = 0
    UpdateBeat:Add(self.Update, self)
end

function BattleManager.Update(self)
    CameraManager:GetInstance():GetBattleCameraField()
    FrameManager:GetInstance():Update(Time.deltaTime)
    local pos1 = self.obj1.transform.position
    local pos2 = self.obj2.transform.position
    ColliderManager:GetInstance():Clean()
    ColliderManager:GetInstance():Stack(Vector2.New(pos1.x,pos1.y),1,1,1)
    ColliderManager:GetInstance():Stack(Vector2.New(pos2.x,pos2.y),1,1,2)
end