---
--- Created by luzhuqiu.
--- DateTime: 2017/6/5 下午2:31
---
local bit = require("bit")
UDPDataPacket = class()
function UDPDataPacket:ctor()
    self.next = nil
    self.last = nil
    self.data = nil
    self.seq = nil
    self.id = nil
end

function UDPDataPacket:Pack(id,seq,originData)
    self.seq = seq
    self.id = id

    local length = string.len(originData)

    local lowID = bit.band(id,255)
    local highID = bit.rshift(id,8)

    local seq1 = bit.band(seq,255)
    local seq2 = bit.band(bit.rshift(seq,8),255)
    local seq3 = bit.band(bit.rshift(seq,16),255)
    local seq4 = bit.band(bit.rshift(seq,24),255)

    --Debugger.LogError('seq  ' .. seq)
    --Debugger.LogError('seq1 ' .. seq1 .. ' seq2 '.. seq2 .. ' seq3 ' .. seq3 .. ' seq4 ' .. seq4)

    local lowLength = bit.band(length,255)
    local highLength = bit.rshift(length,8)

    self.data = string.char(highID) .. string.char(lowID) .. string.char(highLength) .. string.char(lowLength)
    .. string.char(seq4) .. string.char(seq3) .. string.char(seq2) .. string.char(seq1) .. originData

end

function UDPDataPacket:UnPack(originData)
    local datastr = originData:ToLuaBuffer()
    local highID = string.byte(string.sub(datastr,1,1))
    local lowID = string.byte(string.sub(datastr,2,2))
    local highLength = string.byte(string.sub(datastr,3,3))
    local lowLength = string.byte(string.sub(datastr,4,4))
    local seq1 = string.byte(string.sub(datastr,5,5))
    local seq2 = string.byte(string.sub(datastr,6,6))
    local seq3 = string.byte(string.sub(datastr,7,7))
    local seq4 = string.byte(string.sub(datastr,8,8))

    highID = bit.lshift(highID,8)
    local idGet = bit.bor(highID,lowID)

    highLength = bit.lshift(highLength,8)
    local lengthGet = bit.bor(highLength,lowLength)

    seq1 = bit.lshift(seq1,24)
    seq2 = bit.lshift(seq2,16)
    seq3 = bit.lshift(seq3,8)
    local seq = bit.bor(seq1,seq2,seq3,seq4)

    self.id = tonumber(idGet)
    self.length = tonumber(lengthGet)
    self.seq = seq
    self.data = string.sub(datastr,9,9 + self.length - 1)

    --Debugger.LogError('string.len(self.data) ' .. string.len(self.data))
end