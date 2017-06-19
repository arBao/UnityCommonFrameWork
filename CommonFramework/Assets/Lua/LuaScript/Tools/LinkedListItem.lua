---
--- Created by luzhuqiu.
--- DateTime: 2017/6/19 下午12:19
---
require 'Battle/Player/BattleLogicObject'
LinkedListItem = class(BattleLogicObject)
function LinkedListItem:ctor()
    self.next = nil
    self.last = nil
    self.data = nil
end