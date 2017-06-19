---
--- Created by luzhuqiu.
--- DateTime: 2017/6/19 下午2:46
---
require 'Battle/Player/Logic/PlayerLogicLink'
require 'Battle/Player/Logic/PlayerLogicLinkItem'
require 'Battle/Player/Render/PlayerRenderLink'
require 'Battle/Player/Render/PlayerRenderLinkItem'

Player = class(BattleLogicObject)

function Player:Init(id,long,startPos)
    self.id = id
    self.logicLink = PlayerLogicLink.new()
    self.renderLink = PlayerRenderLink.new()
    self.partSpace = 0.3---每一节的间隔距离

    for i = 1,long,1 do
        local logicItem = PlayerLogicLinkItem.new()
        self.logicLink:InsertAtTail(logicItem)
    end
end