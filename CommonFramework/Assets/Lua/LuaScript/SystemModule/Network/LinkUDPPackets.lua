---
--- Created by luzhuqiu.
--- DateTime: 2017/6/5 下午7:50
---
---数据结构为双向链表
LinkUDPPackets = class()

function LinkUDPPackets:ctor()

end

function LinkUDPPackets:Init()
    self.head = nil
    self.tail = nil
end

--isReverse:是否反向遍历
function LinkUDPPackets:PrintLink(isReverse)
    Debugger.LogError("----------------PrintLink-----------------")

    if isReverse then
        local p = self.tail
        if p == nil then
            Debugger.LogError('empty LinkUDPPackets')
            return
        end
        while (p ~= nil)
        do
            Debugger.LogError('p ' .. p.seq)
            p = p.last
        end
    else
        local p = self.head
        if p == nil then
            Debugger.LogError('empty LinkUDPPackets')
            return
        end

        while (p ~= nil)
        do
            Debugger.LogError('p ' .. p.seq)
            p = p.next
        end
    end

end

function LinkUDPPackets:Insert(pInsert)
    local p = self.head
    local lastP = nil
    if p == nil then
        self.head = pInsert
        self.tail = pInsert
        return
    end
    while(p ~= nil)
    do
        lastP = p
        if p.seq == pInsert.seq then
            return
        end
        if pInsert.seq < p.seq then
            pInsert.next = p
            pInsert.last = p.last
            if p.last ~= nil then
                p.last.next = pInsert
            end
            p.last = pInsert
            return
        end
        p = p.next
    end
    lastP.next = pInsert
    pInsert.last = lastP
    self.tail = pInsert
end

function LinkUDPPackets:GetPacketBySeq(seq,isReverse)
    if isReverse then
        local p = self.tail
        while (p ~= nil)
        do
            if p.seq == seq then
                return p
            end
            p = p.last
        end
    else
        local p = self.head
        while (p ~= nil)
        do
            if p.seq == seq then
                return p
            end
            p = p.next
        end
    end
    return null
end