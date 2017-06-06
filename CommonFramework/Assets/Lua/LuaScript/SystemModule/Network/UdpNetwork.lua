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

    UDPServer.Instance:InitUDPServer('127.0.0.1',1110,'127.0.0.1',1111)
    local funcSendSucess = function()
        sendSucess()
    end
    local funcReceiveCallback = function(data)
        local pack = UDPDataPacket.new()
        pack:UnPack(data)
        self.receiveLink:Insert(pack)
        self.receiveLink:CheckLost(pack)
        for k,v in self.receiveLink.lostSeq do
            Debugger.LogError('self.receiveLink.lostSeq  ' .. k)
        end
        if receiveCallback == nil then
            Debugger.LogError('receiveCallback == nil')
        else
            receiveCallback(pack)
        end
    end
    UDPServer.Instance:SetSendSucessCallback(funcSendSucess)
    UDPServer.Instance:SetReceive(funcReceiveCallback)
end

--心跳
function UdpNetwork:SendHeartbeat()

end

--请求服务端重发包
function UdpNetwork:SendRequestSendAgain(seq)

end

--重发队列里面的包
function UdpNetwork:ReSend(seq)
    local packet = self.sendLink:GetPacketBySeq(seq,true)
    if packet ~= nil then
        UDPServer.Instance:SendUDPMsg(packet.data)
    end
end

--发送一个新包
function UdpNetwork:Send(id,data)
    local packet = UDPDataPacket.new()

    packet:Pack(id,self.sendSeq,data)
    self.sendLink:Insert(packet)

    self.sendSeq = self.sendSeq + 1

    UDPServer.Instance:SendUDPMsg(packet.data)
end