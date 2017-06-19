---
--- Created by luzhuqiu.
--- DateTime: 2017/6/16 上午10:59
---
DataPacket = class()

function DataPacket.Packet(id,seq,data)

    local length = string.len(data)

    local lowID = bit.band(id,255)
    local highID = bit.rshift(id,8)

    local seq1 = bit.band(seq,255)
    local seq2 = bit.band(bit.rshift(seq,8),255)
    local seq3 = bit.band(bit.rshift(seq,16),255)
    local seq4 = bit.band(bit.rshift(seq,24),255)

    local lowLength = bit.band(length,255)
    local highLength = bit.rshift(length,8)

    local dataPacket = string.char(highID) .. string.char(lowID) .. string.char(highLength) .. string.char(lowLength)
    .. string.char(seq4) .. string.char(seq3) .. string.char(seq2) .. string.char(seq1) .. data

    return dataPacket
end

function DataPacket.UnPacket(data)
    local highID = string.byte(string.sub(data,1,1))
    local lowID = string.byte(string.sub(data,2,2))
    local highLength = string.byte(string.sub(data,3,3))
    local lowLength = string.byte(string.sub(data,4,4))
    local seq1 = string.byte(string.sub(data,5,5))
    local seq2 = string.byte(string.sub(data,6,6))
    local seq3 = string.byte(string.sub(data,7,7))
    local seq4 = string.byte(string.sub(data,8,8))

    highID = bit.lshift(highID,8)
    local idGet = bit.bor(highID,lowID)

    highLength = bit.lshift(highLength,8)
    local lengthGet = bit.bor(highLength,lowLength)

    seq1 = bit.lshift(seq1,24)
    seq2 = bit.lshift(seq2,16)
    seq3 = bit.lshift(seq3,8)
    local seq = bit.bor(seq1,seq2,seq3,seq4)

    --self.id = tonumber(idGet)
    --self.length = tonumber(lengthGet)
    --self.seq = tonumber(seq)
    --self.data = string.sub(data,9,9 + self.length - 1)

    --local id = tonumber(idGet)
    --local length = tonumber(lengthGet)
    --local seq = tonumber(seq)

    local id = idGet
    local length = lengthGet
    local seq = seq

    local packetTable = {}
    packetTable[1] = id
    packetTable[2] = length
    packetTable[3] = seq
    packetTable[4] = string.sub(data,9,9 + length - 1)

    return packetTable
end