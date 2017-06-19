---
--- Created by luzhuqiu.
--- DateTime: 2017/6/5 下午7:50
---
---数据结构为双向链表
LinkUDPPackets = class()

function LinkUDPPackets:ctor()
    self.head = nil
    self.tail = nil
    self.lostSeq = {}
end

function LinkUDPPackets:Init()

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
---isReverse 是否从尾部开始遍历
function LinkUDPPackets:Insert(pInsert,isReverse)
    if isReverse then
        local p = self.tail
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
            if pInsert.seq > p.seq then

                if p.next ~= nil then
                    p.next.last = pInsert
                else
                    self.tail = pInsert
                end
                pInsert.next = p.next
                p.next = pInsert
                pInsert.last = p

                return
            end
            p = p.last
        end
        pInsert.next = lastP
        lastP.last = pInsert
        self.head = pInsert
    else
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
                if p == self.head then
                    self.head = pInsert
                end
                return
            end
            p = p.next
        end
        lastP.next = pInsert
        pInsert.last = lastP
        self.tail = pInsert
    end

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

function LinkUDPPackets:CheckLost(pack)
    --如果lost数组里面有pack 移除
    self.lostSeq[pack.seq] = nil

    if pack.last ~= nil then
        for i=1,pack.seq - pack.last.seq - 1 do
            self.lostSeq[pack.last.seq + i] = pack.last.seq + i
        end
    end
    if pack.next ~= nil then
        for i=1,pack.next.seq - pack.seq - 1 do
            self.lostSeq[pack.seq + i] = pack.seq + i
        end
    end
end