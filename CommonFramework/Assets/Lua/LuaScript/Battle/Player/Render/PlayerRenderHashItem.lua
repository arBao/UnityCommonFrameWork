---
--- Created by luzhuqiu.
--- DateTime: 2017/6/20 下午5:57
---
require 'Tools/HashItem'
PlayerRenderHashItem = class(HashItem)

function PlayerRenderHashItem:ctor()
    self.gameObject = nil
end