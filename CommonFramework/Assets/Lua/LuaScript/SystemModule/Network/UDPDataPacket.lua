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
    local finalData = ''
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

    self.data = finalData .. lowID .. highID .. lowLength .. highLength .. originData

    Debugger.LogError('self.m_data ' .. self.m_data)
end

function UDPDataPacket:UnPack(originData)
    Debugger.LogError('originData ' .. originData)
end