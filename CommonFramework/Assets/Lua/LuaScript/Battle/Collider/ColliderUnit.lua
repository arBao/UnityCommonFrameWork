--- 碰撞单位方块
--- Created by luzhuqiu.
--- DateTime: 2017/6/9 下午5:36
---

ColliderUnit = class()
function ColliderUnit:Set()
    self.id = 1
    self.ColliderCache = {}
end

function ColliderUnit:Detect()
    return false
end