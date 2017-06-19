---
--- Created by luzhuqiu.
--- DateTime: 2017/6/19 下午12:16
---
require 'Battle/Player/BattleLogicObject'
LinkedList = class(BattleLogicObject)
function LinkedList:ctor()
    self.head = nil
    self.tail = nil
end

function LinkedList:Init()

end

--isReverse:是否反向遍历
function LinkedList:PrintLink(isReverse)
    Debugger.LogError("----------------PrintLink-----------------")

    if isReverse then
        local p = self.tail
        if p == nil then
            Debugger.LogError('empty LinkedList')
            return
        end
        while (p ~= nil)
        do
            Debugger.LogError('p -> ' .. p.data)
            p = p.last
        end
    else
        local p = self.head
        if p == nil then
            Debugger.LogError('empty LinkedList')
            return
        end

        while (p ~= nil)
        do
            Debugger.LogError('p -> ' .. p.data)
            p = p.next
        end
    end

end

function LinkedList:InsertAtTail(pInsert)
    if self.tail == nil then
        self.head = pInsert
        self.tail = pInsert
        return
    end
    pInsert.next = nil
    self.tail.next = pInsert
    pInsert.last = self.tail
    self.tail = pInsert
end

function LinkedList:InsertAtHead(pInsert)
    if self.head == nil then
        self.head = pInsert
        self.tail = pInsert
        return
    end
    pInsert.last = nil
    self.head.last = pInsert
    pInsert.next = self.head
    self.head = pInsert
end

function LinkedList:DeleteAtTail()
    if self.head == self.tail then
        Debugger.LogError('头部等于尾部，不能删除')
        return
    end
    local p = self.tail.last
    p.next = nil
    self.tail = p
end



