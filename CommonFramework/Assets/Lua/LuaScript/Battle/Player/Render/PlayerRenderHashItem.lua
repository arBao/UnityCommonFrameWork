---
--- Created by luzhuqiu.
--- DateTime: 2017/6/20 下午5:57
---
require 'Tools/HashItem'
PlayerRenderHashItem = class(HashItem)

function PlayerRenderHashItem:ctor()
    self.gameObject = nil
    self.lastPosX = 0
    self.lastPosY = 0

    self.targetPosX = 0
    self.targetPosY = 0
    self.time = 0

    self.speedX = 0
    self.speedY = 0

    self.rotation = Quaternion.identity

    self.timeCache = 0
end