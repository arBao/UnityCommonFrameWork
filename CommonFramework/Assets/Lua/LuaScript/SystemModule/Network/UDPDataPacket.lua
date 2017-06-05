---
--- Created by luzhuqiu.
--- DateTime: 2017/6/5 下午2:31
---
local bit = require("bit")
UDPDataPacket = class()
function UDPDataPacket:ctor()
    self.nextUdpPacket = nil
    self.data = nil
    self.seq = nil
    self.id = nil
end

function UDPDataPacket:Pack(id,seq,originData)
    self.seq = seq
    self.id = id

    local length = string.len(originData)
    --Debugger.LogError('id  ' .. id)

    local lowID = bit.band(id,255)
    local highID = bit.rshift(id,8)
    --Debugger.LogError('lowID  ' .. lowID)
    --Debugger.LogError('highID ' .. highID)

    local lowLength = bit.band(length,255)
    local highLength = bit.rshift(length,8)
    --Debugger.LogError('length  ' .. length)
    --Debugger.LogError('lowLength  ' .. lowLength)
    --Debugger.LogError('highLength ' .. highLength)

    self.data = string.char(highID) .. string.char(lowID) .. string.char(highLength) .. string.char(lowLength) .. originData

    --Debugger.LogError('string.len(self.data) ' .. string.len(self.data))
    --Debugger.LogError('string.len(originData) ' .. string.len(originData))

    --Debugger.LogError('self.m_data ' .. self.data)
end

function UDPDataPacket:UnPack(originData)
    local datastr = originData:ToLuaBuffer()
    local highID = string.byte(string.sub(datastr,1,1))
    local lowID = string.byte(string.sub(datastr,2,2))
    local highLength = string.byte(string.sub(datastr,3,3))
    local lowLength = string.byte(string.sub(datastr,4,4))

    --Debugger.LogError('highID ' .. highID)
    --Debugger.LogError('lowID ' .. lowID)

    highID = bit.lshift(highID,8)
    local idGet = bit.bor(highID,lowID)
    --Debugger.LogError('idGet ' .. idGet)

    highLength = bit.lshift(highLength,8)
    local lengthGet = bit.bor(highLength,lowLength)
    --Debugger.LogError('lengthGet ' .. lengthGet)
    --Debugger.LogError('datastr ' .. datastr)

    self.id = tonumber(idGet)
    self.length = tonumber(lengthGet)
    self.data = string.sub(datastr,5,5 + self.length - 1)

    --Debugger.LogError('string.len(self.data) ' .. string.len(self.data))
end