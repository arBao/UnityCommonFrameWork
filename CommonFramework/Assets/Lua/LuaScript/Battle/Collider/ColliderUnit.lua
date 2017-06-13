--- 碰撞单位方块
--- Created by luzhuqiu.
--- DateTime: 2017/6/9 下午5:36
---

ColliderUnit = class()
function ColliderUnit:ctor()
    self.id = 1
    self.x = 0
    self.y = 0
    self.posOrign = nil
    self.colliderTypeList = {}
end

function ColliderUnit:AddType(type)
    table.insert(self.colliderTypeList,type)
end

function ColliderUnit:Detect()
    return false
end