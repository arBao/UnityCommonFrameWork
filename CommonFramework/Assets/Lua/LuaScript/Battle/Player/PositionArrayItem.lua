---
--- Created by luzhuqiu.
--- DateTime: 2017/6/20 下午1:43
---
PositionArrayItem = class()
function PositionArrayItem:ctor()
    self.pos = Vector3.zero
    self.rotation = Quaternion.identity
    self.next = nil
    self.last = nil
    self.time = 0
end