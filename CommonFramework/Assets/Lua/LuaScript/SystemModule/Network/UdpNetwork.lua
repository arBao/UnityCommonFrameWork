---
--- Created by luzhuqiu.
--- DateTime: 2017/6/5 下午2:22
---
require 'SystemModule/Network/UDPDataPacket'
UdpNetwork = class()

function UdpNetwork.Init(sendSucess,receiveCallback)
    UDPServer.Instance:InitUDPServer('127.0.0.1',1111,'127.0.0.1',1110)
    local function funcSendSucess()
        sendSucess()
    end
    local function funcReceiveCallback(data)
        local pack = UDPDataPacket.new()
        pack:UnPack(data)
        receiveCallback(data)
    end
    UDPServer.Instance:SetSendSucessCallback(funcSendSucess)
    UDPServer.Instance:SetReceive(funcReceiveCallback)
end

function UdpNetwork.Send(id,data)
    local packet = UDPDataPacket.new()
    packet:Pack(id,256,data)
    UDPServer.Instance:SendUDPMsg(packet.data)
end