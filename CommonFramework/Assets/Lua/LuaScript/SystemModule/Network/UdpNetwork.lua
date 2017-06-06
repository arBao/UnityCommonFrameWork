---
--- Created by luzhuqiu.
--- DateTime: 2017/6/5 下午2:22
---
require 'SystemModule/Network/UDPDataPacket'
require 'SystemModule/Network/LinkUDPPackets'

UdpNetwork = class()

function UdpNetwork.Init(sendSucess,receiveCallback)
    UDPServer.Instance:InitUDPServer('127.0.0.1',1111,'127.0.0.1',1110)
    local funcSendSucess = function()
        sendSucess()
    end
    local funcReceiveCallback = function(data)
        local pack = UDPDataPacket.new()
        pack:UnPack(data)
        --Debugger.LogError(receiveCallback)
        if receiveCallback == nil then
            --Debugger.LogError('receiveCallback == nil')
        else
            receiveCallback(pack)
        end
    end
    --Debugger.LogError(funcReceiveCallback)
    UDPServer.Instance:SetSendSucessCallback(funcSendSucess)
    UDPServer.Instance:SetReceive(funcReceiveCallback)
end

function UdpNetwork.Send(id,data)
    local packet = UDPDataPacket.new()
    packet:Pack(id,256,data)
    UDPServer.Instance:SendUDPMsg(packet.data)
end