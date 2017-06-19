---
--- Created by luzhuqiu.
--- DateTime: 2017/6/19 下午3:09
---
require 'Tools/LinkedListItem'
PlayerLogicLinkItem = class(LinkedListItem)
function PlayerLogicLinkItem:cotr()
    self.pos = nil
end