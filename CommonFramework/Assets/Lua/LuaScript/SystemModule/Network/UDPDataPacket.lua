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

    local lowLength = bit.band(length,255)
    local highLength = bit.rshift(length,8)

    self.data = string.char(highID) .. string.char(lowID) .. string.char(highLength) .. string.char(lowLength) .. originData

end

function UDPDataPacket:UnPack(originData)
    local datastr = originData:ToLuaBuffer()
    local highID = string.byte(string.sub(datastr,1,1))
    local lowID = string.byte(string.sub(datastr,2,2))
    local highLength = string.byte(string.sub(datastr,3,3))
    local lowLength = string.byte(string.sub(datastr,4,4))

    highID = bit.lshift(highID,8)
    local idGet = bit.bor(highID,lowID)

    highLength = bit.lshift(highLength,8)
    local lengthGet = bit.bor(highLength,lowLength)

    self.id = tonumber(idGet)
    self.length = tonumber(lengthGet)
    self.data = string.sub(datastr,5,5 + self.length - 1)

    --Debugger.LogError('string.len(self.data) ' .. string.len(self.data))
end