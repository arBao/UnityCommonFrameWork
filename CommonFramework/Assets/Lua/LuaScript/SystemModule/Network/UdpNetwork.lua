---
--- Created by luzhuqiu.
--- DateTime: 2017/6/5 下午2:22
---
require 'SystemModule/Network/UDPDataPacket'
require 'SystemModule/Network/LinkUDPPackets'

UdpNetwork = class()

function UdpNetwork:GetInstance()
    if self.m_instance == nil then
        self.m_instance = UdpNetwork.new()
    end
    return self.m_instance
end

function UdpNetwork:Init(sendSucess,receiveCallback)

    self.sendSeq = 0
    self.sendLink = LinkUDPPackets.new()
    self.receiveLink = LinkUDPPackets.new()

    UDPServer.Instance:InitUDPServer('127.0.0.1',1111,'127.0.0.1',1110)
    local funcSendSucess = function()
        sendSucess()
    end
    local funcReceiveCallback = function(data)
        local pack = UDPDataPacket.new()
        pack:UnPack(data)
        if receiveCallback == nil then
            Debugger.LogError('receiveCallback == nil')
        else
            receiveCallback(pack)
        end
    end
    UDPServer.Instance:SetSendSucessCallback(funcSendSucess)
    UDPServer.Instance:SetReceive(funcReceiveCallback)
end

function UdpNetwork:ReSend(id,seq,data)
    local packet = UDPDataPacket.new()
    packet:Pack(id,seq,data)
    UDPServer.Instance:SendUDPMsg(packet.data)
end

function UdpNetwork:Send(id,data)
    local packet = UDPDataPacket.new()

    packet:Pack(id,self.sendSeq,data)
    self.sendLink:Insert(packet)

    self.sendSeq = self.sendSeq + 1

    UDPServer.Instance:SendUDPMsg(packet.data)
end