---
--- Created by luzhuqiu.
--- DateTime: 2017/6/9 下午5:06
---
require 'Battle/Collider/ColliderUnit'
--ColliderType = {['']}

ColliderManager = class()

local rowMax = 100
local lineMax = 100
local lineSpace = 0.1

function ColliderManager:GetInstance()
    if self.m_instance == nil then
        self.m_instance = ColliderManager.new()
    end
    return self.m_instance
end

function ColliderManager:Init()
    self.colliderList = {}
    local id
    local max = math.max(rowMax,lineMax)
    for i = 1,rowMax,1 do
        for j = 1,lineMax,1 do
            id = i * max + j
            local unit = ColliderUnit.new()
            unit.id = id
            self.colliderList[id] = unit
        end
    end
end

---碰撞元素入栈
function ColliderManager:Stack(pos,width,height)
    local row = pos.x / lineSpace
    local line = pos.y / lineSpace

end

---碰撞检测
function ColliderManager:ColliderDetect()

end

function ColliderManager:Draw()

end