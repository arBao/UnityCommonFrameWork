---
--- Created by luzhuqiu.
--- DateTime: 2017/6/20 下午1:43
---
PositionArrayItem = class()
function PositionArrayItem:ctor()
    self.pos = nil
    self.rotation = nil
    self.next = nil
    self.last = nil
end