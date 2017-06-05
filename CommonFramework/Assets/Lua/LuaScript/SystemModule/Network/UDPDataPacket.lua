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
    Debugger.LogError('id  ' .. id)

    local lowID = bit.band(id,255)
    local highID = bit.rshift(id,8)
    Debugger.LogError('lowID  ' .. lowID)
    Debugger.LogError('highID ' .. highID)

    local lowLength = bit.band(length,255)
    local highLength = bit.rshift(length,8)
    Debugger.LogError('length  ' .. length)
    Debugger.LogError('lowLength  ' .. lowLength)
    Debugger.LogError('highLength ' .. highLength)

    self.data = highID .. lowID .. highLength .. lowLength .. originData

    self.data = id .. length .. originData

    Debugger.LogError('self.m_data ' .. self.data)
end

function UDPDataPacket:UnPack(originData)
    local datastr = originData:ToLuaBuffer()
    local highID = string.sub(datastr,1,1)
    local lowID = string.sub(datastr,2,2)
    local highLength = string.sub(datastr,3,3)
    local lowLength = string.sub(datastr,4,4)

    Debugger.LogError('highID ' .. highID)
    Debugger.LogError('lowID ' .. lowID)

    highID = bit.lshift(highID,8)
    local id = bit.bor(highID,lowID)
    Debugger.LogError('id ' .. id)
    Debugger.LogError('datastr ' .. datastr)
end