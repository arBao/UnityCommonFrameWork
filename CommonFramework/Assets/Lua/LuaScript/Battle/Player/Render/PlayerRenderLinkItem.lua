---
--- Created by luzhuqiu.
--- DateTime: 2017/6/19 下午3:03
---
require 'Tools/LinkedList'
PlayerRenderLinkItem = class(LinkedListItem)
function PlayerRenderLinkItem:ctor()
    self.id = nil
    self.pos = nil
    self.rotation = nil
end