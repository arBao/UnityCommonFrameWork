---
--- Created by luzhuqiu.
--- DateTime: 2017/6/22 下午5:47
---
BattleData = class()
function BattleData:ctor()
    self.score = 100
    self.isSpeeding = false
    self.directionX = 1
    self.directionY = 1
end