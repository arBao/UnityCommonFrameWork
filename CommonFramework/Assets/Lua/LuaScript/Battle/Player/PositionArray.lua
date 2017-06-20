---
--- Created by luzhuqiu.
--- DateTime: 2017/6/20 下午1:43
--- 位置信息数据结构
require 'Battle/Player/PositionArrayItem'

PositionArray = class()
function PositionArray:ctor()
    self.size = 0
    self.head = nil
    self.tail = nil
    self.unuseItem = nil

    self.posArray = {}
end

function PositionArray:GetSize()
    return self.size
end

function PositionArray:SetSize(size)
    if self.size == size then
        return
    end

    if size > self.size then
        local delta = size - self.size
        for i = 1,delta,1 do
            local posItem = nil
            if self.unuseItem ~= nil then
                --Debugger.LogError('取员')
                posItem = self.unuseItem
                self.unuseItem = self.unuseItem.next
            else
                posItem = PositionArrayItem.new()
                --Debugger.LogError('增员')
            end

            if self.head == nil then
                self.head = posItem
                self.tail = posItem
            else
                posItem.last = self.tail
                posItem.next = nil
                self.tail.next = posItem
                self.tail = posItem
            end
            if posItem.last ~= nil then
                local pos = posItem.last.pos
                posItem.pos.x = pos.x
                posItem.pos.y = pos.y
                posItem.rotation = posItem.last.rotation
            end
        end
    else
        --Debugger.LogError('减员')
        local p = self.head
        for i = 1,size,1 do
            p = p.next
        end
        self.tail = p.last
        p.last.next = nil
        self.unuseItem = p
    end

    self.size = size
end

function PositionArray:ForEach(func)
    local p = self.head
    while(p ~= nil)
    do
        if func ~= nil then
            func(p)
        end
        p = p.next
    end
end

function PositionArray:Push(posX,posY,rotation)
    local p = self.tail
    self.tail = p.last
    p.last.next = nil
    p.last = nil

    p.next = self.head
    self.head.last = p
    self.head = p

    p.pos.x = posX
    p.pos.y = posY
    p.rotation = rotation
end