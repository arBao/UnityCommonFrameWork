---
--- Created by luzhuqiu.
--- DateTime: 2017/6/19 下午3:03
---
require 'Tools/LinkedList'
PlayerLogicLink = class(LinkedList)
function PlayerLogicLink:ctor()
    self.items = {}
end

