---
--- Created by luzhuqiu.
--- DateTime: 2017/6/7 下午2:45
---
require 'Battle/Player/PlayerCreator'
require 'Battle/FrameSyncSystem/FrameManager'
require 'Battle/Collider/ColliderManager'
require 'Battle/Process/ProcessManager'
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
    self.obj2 = PlayerCreator:GetInstance():Create(Vector3.New(2,0,0))
    self.obj3 = PlayerCreator:GetInstance():Create(Vector3.New(4,0,0))
    local GameLogicUpdateFunc = function(deltaTime)
        --local pos = obj.transform.position
        --pos.x = pos.x + deltaTime * 1 * self.direction.x
        --pos.y = pos.y + deltaTime * 1 * self.direction.y
        --obj.transform.position = pos
    end
    FrameManager:GetInstance():Init(GameLogicUpdateFunc)
    ColliderManager:GetInstance():Init()
    ProcessManager:GetInstance():Init('ProcessModeNormal')
    BattleEventsManager:GetInstance():Send('BattleReady',nil)
    Debugger.LogError('Send  BattleReady')
end



function BattleManager:Ready()

end

function BattleManager:Start()
    --预留processmanager
    self.time = 0
    UpdateBeat:Add(self.Update, self)
end

function BattleManager.Update(self)
    ProcessManager:GetInstance():Update(Time.deltaTime)
    CameraManager:GetInstance():GetBattleCameraField()
    FrameManager:GetInstance():Update(Time.deltaTime)
    local pos1 = self.obj1.transform.position
    local pos2 = self.obj2.transform.position
    local pos3 = self.obj3.transform.position
    ColliderManager:GetInstance():Clean()
    ColliderManager:GetInstance():Stack(Vector2.New(pos1.x,pos1.y),1,1,111,1)
    ColliderManager:GetInstance():Stack(Vector2.New(pos2.x,pos2.y),1,1,222,2)
    ColliderManager:GetInstance():Stack(Vector2.New(pos3.x,pos3.y),1,1,333,3)
    local pairs = ColliderManager:GetInstance():ColliderDetect()
    if #pairs ~= 0 then
        Debugger.LogError('--------------------' )
    end

    for i=1,#pairs do
        local pair = pairs[i]
        Debugger.LogError('##########' )
        Debugger.LogError('pair.element1.id  ' .. pair.element1.id .. '  pair.element1.type  ' .. pair.element1.type )
        Debugger.LogError('pair.element2.id  ' .. pair.element2.id .. '  pair.element2.type  ' .. pair.element2.type )
    end
end

function BattleManager:Clear()

end