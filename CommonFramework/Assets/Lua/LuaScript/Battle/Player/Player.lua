---
--- Created by luzhuqiu.
--- DateTime: 2017/6/19 下午2:46
---
require 'Battle/Player/Logic/PlayerLogicLink'
require 'Battle/Player/Logic/PlayerLogicLinkItem'
require 'Battle/Player/Render/PlayerRenderLink'
require 'Battle/Player/Render/PlayerRenderLinkItem'
require 'Battle/Player/PositionArray'

Player = class(BattleLogicObject)

function Player:Init(id,long,startPos)
    self.id = id
    self.logicLink = PlayerLogicLink.new()
    self.renderLink = PlayerRenderLink.new()
    self.partSpace = 0.3---每一节的间隔距离
    self.runSpeed = 0.1---行进速度
    self.rotateSpeed = 0.1---旋转速度

    for i = 1,long,1 do
        local logicItem = PlayerLogicLinkItem.new()
        local renderItem = PlayerRenderLinkItem.new()

        self.logicLink:InsertAtTail(logicItem)
        self.renderLink:InsertAtTail(renderItem)

        local pos = Vector3.New(startPos.x,startPos.y,startPos.z)

        logicItem.pos = pos
        logicItem.id = self.id .. '_' .. i

        renderItem.pos = pos
        renderItem.id = self.id .. '_' .. i

        if pos.x >= 0 then
            renderItem.rotation = Quaternion.Euler(0,0,90)
        else
            renderItem.rotation = Quaternion.Euler(0,0,-90)
        end
    end

    local positionArray = PositionArray.new()
    --------------------------------------------------------
    positionArray:SetSize(10)

    for i = 1,10,1 do
        positionArray:Push(Vector3.New(0,0,0))
    end

    local cnt = 1
    positionArray:ForEach(function(item)
        Debugger.LogError('item  item.position.x ' .. item.position.x .. '  item.position.y  ' .. item.position.y .. ' item.position.z ' .. item.position.z .. '  cnt  ' .. cnt)
        cnt = cnt + 1
    end)

    --------------------------------------------------------
    positionArray:Push(Vector3.New(1,0,0))

    Debugger.LogError('------------##############')

    cnt = 1
    positionArray:ForEach(function(item)
        Debugger.LogError('item  item.position.x ' .. item.position.x .. '  item.position.y  ' .. item.position.y .. ' item.position.z ' .. item.position.z .. '  cnt  ' .. cnt)
        cnt = cnt + 1
    end)

    --------------------------------------------------------
    positionArray:Push(Vector3.New(2,0,0))

    Debugger.LogError('------------##############')

    cnt = 1
    positionArray:ForEach(function(item)
        Debugger.LogError('item  item.position.x ' .. item.position.x .. '  item.position.y  ' .. item.position.y .. ' item.position.z ' .. item.position.z .. '  cnt  ' .. cnt)
        cnt = cnt + 1
    end)

    --------------------------------------------------------
    positionArray:SetSize(5)

    Debugger.LogError('------------##############')

    cnt = 1
    positionArray:ForEach(function(item)
        Debugger.LogError('item  item.position.x ' .. item.position.x .. '  item.position.y  ' .. item.position.y .. ' item.position.z ' .. item.position.z .. '  cnt  ' .. cnt)
        cnt = cnt + 1
    end)

    --------------------------------------------------------
    positionArray:SetSize(8)

    Debugger.LogError('------------##############')

    cnt = 1
    positionArray:ForEach(function(item)
        Debugger.LogError('item  item.position.x ' .. item.position.x .. '  item.position.y  ' .. item.position.y .. ' item.position.z ' .. item.position.z .. '  cnt  ' .. cnt)
        cnt = cnt + 1
    end)

end

function Player:Move(time)
    local distance = self.runSpeed * time
    self.logicLink:ForEach(
    function(linkItem)
        if linkItem == self.logicLink.head then
            linkItem.pos.x = linkItem.pos.x + distance
        end
    end)
end