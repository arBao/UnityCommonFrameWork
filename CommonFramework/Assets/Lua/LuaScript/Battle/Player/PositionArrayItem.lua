---
--- Created by luzhuqiu.
--- DateTime: 2017/6/20 下午1:43
---
PositionArrayItem = class()
function PositionArrayItem:ctor()
    self.posX = 0
    self.posY = 0
    self.rotationZ = 0
    self.next = nil
    self.last = nil
    --self.time = 0
end